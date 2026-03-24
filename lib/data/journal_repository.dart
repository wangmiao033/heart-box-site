import 'package:sqflite/sqflite.dart';

import '../core/db/app_database.dart';
import '../models/journal_entry.dart';

class JournalRepository {
  JournalRepository(this._db);

  final AppDatabase _db;

  Future<Database> get _database => _db.database;

  Future<List<JournalEntry>> listRecent({String? query}) async {
    final db = await _database;
    final q = query?.trim();
    List<Map<String, Object?>> rows;
    if (q == null || q.isEmpty) {
      rows = await db.rawQuery('''
SELECT e.* FROM entries e
ORDER BY e.created_at DESC
''');
    } else {
      final safe = q.replaceAll('%', '').replaceAll('_', '').trim();
      if (safe.isEmpty) {
        rows = await db.rawQuery('''
SELECT e.* FROM entries e
ORDER BY e.created_at DESC
''');
      } else {
        final like = '%$safe%';
        rows = await db.rawQuery(
          '''
SELECT DISTINCT e.* FROM entries e
LEFT JOIN entry_tags et ON et.entry_id = e.id
LEFT JOIN tags t ON t.id = et.tag_id
WHERE e.content LIKE ?
   OR t.name LIKE ?
ORDER BY e.created_at DESC
''',
          [like, like],
        );
      }
    }
    return _hydrateRows(db, rows);
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
    required String content,
    required int moodIndex,
    required List<String> tagNames,
  }) async {
    final db = await _database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = await db.insert('entries', {
      'content': content,
      'mood_index': moodIndex,
      'created_at': now,
      'updated_at': now,
    });
    await _syncTagsForEntry(db, id, tagNames);
    return id;
  }

  Future<void> update({
    required int id,
    required String content,
    required int moodIndex,
    required List<String> tagNames,
  }) async {
    final db = await _database;
    await db.update(
      'entries',
      {
        'content': content,
        'mood_index': moodIndex,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    await db.delete('entry_tags', where: 'entry_id = ?', whereArgs: [id]);
    await _syncTagsForEntry(db, id, tagNames);
  }

  Future<void> delete(int id) async {
    final db = await _database;
    await db.delete('entries', where: 'id = ?', whereArgs: [id]);
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
    return JournalEntry(
      id: r['id'] as int,
      content: r['content'] as String,
      moodIndex: (r['mood_index'] as int?) ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(r['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(r['updated_at'] as int),
      tags: List<String>.from(tags),
    );
  }
}
