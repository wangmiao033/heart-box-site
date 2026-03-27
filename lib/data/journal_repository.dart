import 'dart:math';

import 'package:sqflite/sqflite.dart';

import '../core/db/app_database.dart';
import '../core/storage/journal_image_store.dart';
import '../models/journal_entry.dart';
import '../models/journal_image_ref.dart';

class JournalRepository {
  JournalRepository(this._db, this._imageStore);

  final AppDatabase _db;
  final JournalImageStore _imageStore;

  Future<Database> get _database => _db.database;

  /// 列表：支持关键词（标题/正文/标签名模糊）与精确标签筛选（可并存）。
  Future<List<JournalEntry>> listRecent({
    String? query,
    String? tagFilter,
  }) async {
    final db = await _database;
    final qRaw = query?.trim() ?? '';
    final safe = qRaw.replaceAll('%', '').replaceAll('_', '').trim();
    final tag = tagFilter?.trim() ?? '';
    final hasQ = safe.isNotEmpty;
    final hasTag = tag.isNotEmpty;

    List<Map<String, Object?>> rows;

    if (!hasQ && !hasTag) {
      rows = await db.rawQuery('''
SELECT e.* FROM entries e
ORDER BY e.created_at DESC
''');
    } else if (hasTag && !hasQ) {
      rows = await db.rawQuery(
        '''
SELECT DISTINCT e.* FROM entries e
INNER JOIN entry_tags et ON et.entry_id = e.id
INNER JOIN tags t ON t.id = et.tag_id AND t.name = ? COLLATE NOCASE
ORDER BY e.created_at DESC
''',
        [tag],
      );
    } else if (hasQ && !hasTag) {
      final like = '%$safe%';
      rows = await db.rawQuery(
        '''
SELECT DISTINCT e.* FROM entries e
LEFT JOIN entry_tags et ON et.entry_id = e.id
LEFT JOIN tags t ON t.id = et.tag_id
WHERE e.content LIKE ?
   OR e.title LIKE ?
   OR t.name LIKE ?
ORDER BY e.created_at DESC
''',
        [like, like, like],
      );
    } else {
      final like = '%$safe%';
      rows = await db.rawQuery(
        '''
SELECT DISTINCT e.* FROM entries e
INNER JOIN entry_tags et0 ON et0.entry_id = e.id
INNER JOIN tags t0 ON t0.id = et0.tag_id AND t0.name = ? COLLATE NOCASE
WHERE e.content LIKE ?
   OR e.title LIKE ?
   OR EXISTS (
     SELECT 1 FROM entry_tags etx
     JOIN tags tx ON tx.id = etx.tag_id
     WHERE etx.entry_id = e.id AND tx.name LIKE ?
   )
ORDER BY e.created_at DESC
''',
        [tag, like, like, like],
      );
    }
    return _hydrateRows(db, rows);
  }

  /// 导出用：按创建时间升序（便于阅读时间线）。
  Future<List<JournalEntry>> listAllForExport() async {
    final db = await _database;
    final rows = await db.rawQuery('''
SELECT e.* FROM entries e
ORDER BY e.created_at ASC
''');
    return _hydrateRows(db, rows);
  }

  /// 自然日 -> 当天记录条数。
  Future<Map<DateTime, int>> entryCountsByDay() async {
    final db = await _database;
    final rows = await db.query('entries', columns: ['created_at']);
    final map = <DateTime, int>{};
    for (final r in rows) {
      final ms = r['created_at'] as int?;
      if (ms == null) continue;
      final d = DateTime.fromMillisecondsSinceEpoch(ms);
      final key = DateTime(d.year, d.month, d.day);
      map[key] = (map[key] ?? 0) + 1;
    }
    return map;
  }

  /// 与 [reference] 同月同日，且排除「reference 当天」公历日上的记录（一般为今天），即往年今日。
  Future<List<JournalEntry>> listOnSameMonthDayExcludingCurrentYear([
    DateTime? reference,
  ]) async {
    final ref = reference ?? DateTime.now();
    final ry = ref.year;
    final rm = ref.month;
    final rd = ref.day;
    final db = await _database;
    final rows = await db.rawQuery(
      'SELECT e.* FROM entries e ORDER BY e.created_at DESC',
    );
    final list = await _hydrateRows(db, rows);
    return list.where((e) {
      final d = e.createdAt;
      final sameMd = d.month == rm && d.day == rd;
      final isRefCalendarDay =
          d.year == ry && d.month == rm && d.day == rd;
      return sameMd && !isRefCalendarDay;
    }).toList();
  }

  /// 随机一条；若传入 [avoidId] 且还有其他条，则尽量避开该 id。
  Future<JournalEntry?> pickRandomEntry({int? avoidId}) async {
    final db = await _database;
    final rows = await db.rawQuery('SELECT e.* FROM entries e');
    if (rows.isEmpty) return null;
    final list = await _hydrateRows(db, rows);
    if (list.length == 1) return list.first;

    var pool =
        avoidId != null ? list.where((e) => e.id != avoidId).toList() : list;
    if (pool.isEmpty) pool = list;

    final i = Random().nextInt(pool.length);
    return pool[i];
  }

  Future<List<JournalEntry>> listBetween(DateTime from, DateTime to) async {
    final db = await _database;
    final a = from.millisecondsSinceEpoch;
    final b = to.millisecondsSinceEpoch;
    final rows = await db.rawQuery(
      '''
SELECT e.* FROM entries e
WHERE e.created_at BETWEEN ? AND ?
ORDER BY e.created_at DESC
''',
      [a, b],
    );
    return _hydrateRows(db, rows);
  }

  Future<List<JournalEntry>> listForDay(DateTime day) async {
    final db = await _database;
    final start = DateTime(day.year, day.month, day.day).millisecondsSinceEpoch;
    final end = DateTime(day.year, day.month, day.day, 23, 59, 59, 999)
        .millisecondsSinceEpoch;
    final rows = await db.rawQuery(
      '''
SELECT e.* FROM entries e
WHERE e.created_at BETWEEN ? AND ?
ORDER BY e.created_at DESC
''',
      [start, end],
    );
    return _hydrateRows(db, rows);
  }

  Future<Set<DateTime>> daysWithEntries() async {
    final db = await _database;
    final rows = await db.rawQuery(
      'SELECT created_at FROM entries',
    );
    final set = <DateTime>{};
    for (final r in rows) {
      final ms = r['created_at'] as int?;
      if (ms == null) continue;
      final d = DateTime.fromMillisecondsSinceEpoch(ms);
      set.add(DateTime(d.year, d.month, d.day));
    }
    return set;
  }

  Future<JournalEntry?> getById(int id) async {
    final db = await _database;
    final rows = await db.query('entries', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    final list = await _hydrateRows(db, rows);
    return list.first;
  }

  Future<int> insert({
    String title = '',
    required String content,
    required int moodIndex,
    required List<String> tagNames,
    List<JournalImageRef> images = const [],
    int? createdAtMs,
    int? updatedAtMs,
  }) async {
    assert(images.length <= kMaxJournalImages);
    final db = await _database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final c = createdAtMs ?? now;
    final u = updatedAtMs ?? now;
    final id = await db.insert('entries', {
      'title': title,
      'content': content,
      'mood_index': moodIndex,
      'created_at': c,
      'updated_at': u,
      'images_json': JournalImageRef.encodeList(images),
      'cloud_id': null,
      'cloud_owner_id': null,
      'sync_status': 'pending',
      'last_synced_at': null,
    });
    await _syncTagsForEntry(db, id, tagNames);
    return id;
  }

  Future<void> update({
    required int id,
    String title = '',
    required String content,
    required int moodIndex,
    required List<String> tagNames,
    List<JournalImageRef> images = const [],
  }) async {
    assert(images.length <= kMaxJournalImages);
    final old = await getById(id);
    final db = await _database;
    await db.update(
      'entries',
      {
        'title': title,
        'content': content,
        'mood_index': moodIndex,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
        'images_json': JournalImageRef.encodeList(images),
        'sync_status': 'pending',
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    await db.delete('entry_tags', where: 'entry_id = ?', whereArgs: [id]);
    await _syncTagsForEntry(db, id, tagNames);
    if (old != null) {
      final removed = <JournalImageRef>[];
      for (final o in old.images) {
        if (!images.contains(o)) removed.add(o);
      }
      if (removed.isNotEmpty) {
        await _imageStore.deleteRefs(removed);
      }
    }
  }

  /// [purgeAttachments] 为 false 时仅删库内行，不删本地图片文件（供撤销删除等场景延后清理）。
  Future<void> delete(int id, {bool purgeAttachments = true}) async {
    final db = await _database;
    JournalEntry? entry;
    if (purgeAttachments) {
      entry = await getById(id);
    }
    await db.delete('entries', where: 'id = ?', whereArgs: [id]);
    if (purgeAttachments && entry != null && entry.images.isNotEmpty) {
      await _imageStore.deleteRefs(entry.images);
    }
  }

  Future<List<String>> allTagNames() async {
    final db = await _database;
    final rows = await db.query('tags', orderBy: 'name COLLATE NOCASE ASC');
    return rows.map((e) => e['name'] as String).toList();
  }

  Future<void> _syncTagsForEntry(Database db, int entryId, List<String> names) async {
    final normalized = <String>{};
    for (final raw in names) {
      final n = raw.trim();
      if (n.isEmpty) continue;
      normalized.add(n);
    }
    for (final name in normalized) {
      var tagId = await _findTagIdByName(db, name);
      tagId ??= await db.insert('tags', {'name': name});
      await db.insert('entry_tags', {'entry_id': entryId, 'tag_id': tagId},
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  Future<int?> _findTagIdByName(Database db, String name) async {
    final rows = await db.query(
      'tags',
      columns: ['id'],
      where: 'name = ? COLLATE NOCASE',
      whereArgs: [name],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['id'] as int;
  }

  Future<List<JournalEntry>> _hydrateRows(
    Database db,
    List<Map<String, Object?>> rows,
  ) async {
    if (rows.isEmpty) return [];
    final ids = rows.map((e) => e['id'] as int).toList();
    final placeholders = List.filled(ids.length, '?').join(',');
    final tagRows = await db.rawQuery(
      '''
SELECT et.entry_id AS entry_id, t.name AS name
FROM entry_tags et
JOIN tags t ON t.id = et.tag_id
WHERE et.entry_id IN ($placeholders)
ORDER BY t.name COLLATE NOCASE
''',
      ids,
    );
    final byEntry = <int, List<String>>{};
    for (final tr in tagRows) {
      final eid = tr['entry_id'] as int;
      final name = tr['name'] as String;
      byEntry.putIfAbsent(eid, () => []).add(name);
    }
    return rows.map((r) => _fromRow(r, byEntry[r['id'] as int] ?? [])).toList();
  }

  JournalEntry _fromRow(Map<String, Object?> r, List<String> tags) {
    final titleRaw = r['title'] as String?;
    final imgRaw = r['images_json'] as String?;
    final lsa = r['last_synced_at'] as int?;
    return JournalEntry(
      id: r['id'] as int,
      title: titleRaw ?? '',
      content: r['content'] as String,
      moodIndex: (r['mood_index'] as int?) ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(r['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(r['updated_at'] as int),
      tags: List<String>.from(tags),
      images: JournalImageRef.decodeList(imgRaw),
      cloudId: r['cloud_id'] as String?,
      cloudOwnerId: r['cloud_owner_id'] as String?,
      syncStatus: (r['sync_status'] as String?) ?? 'pending',
      lastSyncedAt:
          lsa != null ? DateTime.fromMillisecondsSinceEpoch(lsa) : null,
    );
  }

  // —— 云同步（JournalSyncService 使用）——

  Future<JournalEntry?> getByCloudId(String cloudId) async {
    final db = await _database;
    final rows = await db.query(
      'entries',
      where: 'cloud_id = ?',
      whereArgs: [cloudId],
    );
    if (rows.isEmpty) return null;
    final list = await _hydrateRows(db, rows);
    return list.first;
  }

  Future<void> deleteByCloudId(String cloudId) async {
    final e = await getByCloudId(cloudId);
    if (e == null) return;
    await delete(e.id, purgeAttachments: true);
  }

  Future<List<JournalEntry>> listEntriesEligibleForPush(String userId) async {
    final db = await _database;
    final rows = await db.rawQuery(
      '''
SELECT e.* FROM entries e
WHERE e.sync_status IN ('pending', 'failed')
  AND (e.cloud_owner_id IS NULL OR e.cloud_owner_id = ?)
ORDER BY e.id ASC
''',
      [userId],
    );
    return _hydrateRows(db, rows);
  }

  Future<int> countPendingForUser(String userId) async {
    final db = await _database;
    final rows = await db.rawQuery(
      '''
SELECT COUNT(*) AS c FROM entries e
WHERE e.sync_status IN ('pending', 'failed')
  AND (e.cloud_owner_id IS NULL OR e.cloud_owner_id = ?)
''',
      [userId],
    );
    final n = rows.first['c'];
    if (n is int) return n;
    return (n as num?)?.toInt() ?? 0;
  }

  Future<int> insertFromRemote({
    required String cloudId,
    required String cloudOwnerId,
    required String title,
    required String content,
    required int moodIndex,
    required List<String> tags,
    required int createdAtMs,
    required int updatedAtMs,
  }) async {
    final db = await _database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = await db.insert('entries', {
      'title': title,
      'content': content,
      'mood_index': moodIndex,
      'created_at': createdAtMs,
      'updated_at': updatedAtMs,
      'images_json': JournalImageRef.encodeList(const []),
      'cloud_id': cloudId,
      'cloud_owner_id': cloudOwnerId,
      'sync_status': 'synced',
      'last_synced_at': now,
    });
    await _syncTagsForEntry(db, id, tags);
    return id;
  }

  Future<void> updateTextFromRemoteMerge({
    required int localId,
    required String cloudId,
    required String cloudOwnerId,
    required String title,
    required String content,
    required int moodIndex,
    required List<String> tagNames,
    required int createdAtMs,
    required int updatedAtMs,
  }) async {
    final db = await _database;
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.update(
      'entries',
      {
        'title': title,
        'content': content,
        'mood_index': moodIndex,
        'created_at': createdAtMs,
        'updated_at': updatedAtMs,
        'cloud_id': cloudId,
        'cloud_owner_id': cloudOwnerId,
        'sync_status': 'synced',
        'last_synced_at': now,
      },
      where: 'id = ?',
      whereArgs: [localId],
    );
    await db.delete('entry_tags', where: 'entry_id = ?', whereArgs: [localId]);
    await _syncTagsForEntry(db, localId, tagNames);
  }

  Future<void> markLocalSyncedAfterPush({
    required int localId,
    required String cloudId,
    required String cloudOwnerId,
  }) async {
    final db = await _database;
    await db.update(
      'entries',
      {
        'cloud_id': cloudId,
        'cloud_owner_id': cloudOwnerId,
        'sync_status': 'synced',
        'last_synced_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [localId],
    );
  }

  Future<void> markSyncFailed(int localId) async {
    final db = await _database;
    await db.update(
      'entries',
      {'sync_status': 'failed'},
      where: 'id = ?',
      whereArgs: [localId],
    );
  }
}
