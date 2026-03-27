import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/journal_repository.dart';
import '../../models/journal_entry.dart';

/// 文本日记与 Supabase `journal_entries` 的合并与推送（MVP）。
///
/// 冲突：比较 [JournalEntry.updatedAt] 与云端 `updated_at`，较新一方覆盖较旧一方正文与标签；
/// 本地图片字段不因拉取被清空（合并时只改文本相关列）。
class JournalSyncService {
  JournalSyncService(this._repo, this._client);

  final JournalRepository _repo;
  final SupabaseClient _client;

  static const _table = 'journal_entries';

  Future<void> runFullSync({
    required String userId,
    required void Function() onJournalChanged,
  }) async {
    await _pull(userId: userId, onJournalChanged: onJournalChanged);
    await _push(userId: userId, onJournalChanged: onJournalChanged);
  }

  /// 删除前调用：在云端标记软删。失败时由调用方决定是否仍删本地。
  Future<void> pushTombstone({
    required String userId,
    required String cloudId,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await _client.from(_table).update({
      'deleted_at': now,
      'updated_at': now,
    }).eq('id', cloudId).eq('user_id', userId);
  }

  Future<void> _pull({
    required String userId,
    required void Function() onJournalChanged,
  }) async {
    final raw = await _client.from(_table).select();
    final list = raw as List<dynamic>;

    var changed = false;
    for (final item in list) {
      final row = Map<String, dynamic>.from(item as Map);
      final id = row['id']?.toString();
      if (id == null || id.isEmpty) continue;

      final deletedAt = row['deleted_at'];
      if (deletedAt != null) {
        await _repo.deleteByCloudId(id);
        changed = true;
        continue;
      }

      final remoteUpdated = _parseTs(row['updated_at']);
      final remoteCreated = _parseTs(row['created_at']);
      final title = (row['title'] as String?) ?? '';
      final body = (row['body'] as String?) ?? '';
      final mood = (row['mood_index'] as num?)?.toInt() ?? 0;
      final tags = _parseTags(row['tags']);

      final local = await _repo.getByCloudId(id);
      if (local == null) {
        await _repo.insertFromRemote(
          cloudId: id,
          cloudOwnerId: userId,
          title: title,
          content: body,
          moodIndex: mood,
          tags: tags,
          createdAtMs: remoteCreated.millisecondsSinceEpoch,
          updatedAtMs: remoteUpdated.millisecondsSinceEpoch,
        );
        changed = true;
      } else {
        final cmp = _compareUpdated(local.updatedAt, remoteUpdated);
        if (cmp < 0) {
          await _repo.updateTextFromRemoteMerge(
            localId: local.id,
            cloudId: id,
            cloudOwnerId: userId,
            title: title,
            content: body,
            moodIndex: mood,
            tagNames: tags,
            createdAtMs: remoteCreated.millisecondsSinceEpoch,
            updatedAtMs: remoteUpdated.millisecondsSinceEpoch,
          );
          changed = true;
        }
      }
    }
    if (changed) onJournalChanged();
  }

  Future<void> _push({
    required String userId,
    required void Function() onJournalChanged,
  }) async {
    final list = await _repo.listEntriesEligibleForPush(userId);
    if (list.isEmpty) return;

    var changed = false;
    for (final e in list) {
      if (!_canPushEntry(e, userId)) continue;

      try {
        if (e.cloudId == null || e.cloudId!.isEmpty) {
          final res = await _client.from(_table).insert({
            'user_id': userId,
            'mood_index': e.moodIndex,
            'title': e.title,
            'body': e.content,
            'tags': e.tags,
            'created_at': e.createdAt.toUtc().toIso8601String(),
            'updated_at': e.updatedAt.toUtc().toIso8601String(),
          }).select('id').single();
          final cid = res['id']?.toString();
          if (cid == null || cid.isEmpty) {
            await _repo.markSyncFailed(e.id);
          } else {
            await _repo.markLocalSyncedAfterPush(
              localId: e.id,
              cloudId: cid,
              cloudOwnerId: userId,
            );
            changed = true;
          }
        } else {
          final remote = await _client
              .from(_table)
              .select('updated_at')
              .eq('id', e.cloudId!)
              .eq('user_id', userId)
              .maybeSingle();

          if (remote != null) {
            final ru = _parseTs(remote['updated_at']);
            if (_compareUpdated(e.updatedAt, ru) < 0) {
              continue;
            }
          }

          await _client.from(_table).update({
            'mood_index': e.moodIndex,
            'title': e.title,
            'body': e.content,
            'tags': e.tags,
            'updated_at': e.updatedAt.toUtc().toIso8601String(),
            'deleted_at': null,
          }).eq('id', e.cloudId!).eq('user_id', userId);

          await _repo.markLocalSyncedAfterPush(
            localId: e.id,
            cloudId: e.cloudId!,
            cloudOwnerId: userId,
          );
          changed = true;
        }
      } catch (_) {
        await _repo.markSyncFailed(e.id);
      }
    }
    if (changed) onJournalChanged();
  }

  static bool _canPushEntry(JournalEntry e, String userId) {
    if (e.cloudOwnerId != null && e.cloudOwnerId != userId) return false;
    return true;
  }

  /// &lt;0：a 早于 b；0：相等；&gt;0：a 晚于 b
  static int _compareUpdated(DateTime a, DateTime b) {
    final x = a.toUtc().millisecondsSinceEpoch;
    final y = b.toUtc().millisecondsSinceEpoch;
    return x.compareTo(y);
  }

  static DateTime _parseTs(dynamic v) {
    if (v == null) return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    return DateTime.parse(v.toString()).toUtc();
  }

  static List<String> _parseTags(dynamic v) {
    if (v == null) return [];
    if (v is List) {
      return v.map((e) => e.toString()).toList();
    }
    return [];
  }
}
