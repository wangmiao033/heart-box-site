import 'dart:convert';

import '../../models/journal_image_ref.dart';
import '../../models/mood_kind.dart';

/// 记一笔 / 编辑页的本地草稿（仅本地持久化，不参与同步）。
class ComposeDraft {
  const ComposeDraft({
    required this.entryId,
    required this.moodIndex,
    required this.title,
    required this.content,
    required this.tagsRaw,
    required this.updatedAtMs,
    this.imagesJson = '[]',
  });

  /// 新建为 null；编辑为日记 id。
  final int? entryId;
  final int moodIndex;
  final String title;
  final String content;
  final String tagsRaw;
  final int updatedAtMs;
  /// [JournalImageRef.encodeList] 结果。
  final String imagesJson;

  /// 是否值得弹出「恢复」提示（全空且心情为默认且无图则不提示）。
  bool get isMeaningful =>
      content.trim().isNotEmpty ||
      title.trim().isNotEmpty ||
      tagsRaw.trim().isNotEmpty ||
      moodIndex != MoodKind.calm.storageIndex ||
      JournalImageRef.decodeList(imagesJson).isNotEmpty;

  String toJsonString() => jsonEncode({
        'entryId': entryId,
        'moodIndex': moodIndex,
        'title': title,
        'content': content,
        'tagsRaw': tagsRaw,
        'updatedAtMs': updatedAtMs,
        'imagesJson': imagesJson,
      });

  static ComposeDraft? fromStored(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      return ComposeDraft(
        entryId: (m['entryId'] as num?)?.toInt(),
        moodIndex: (m['moodIndex'] as num).toInt(),
        title: m['title'] as String? ?? '',
        content: m['content'] as String? ?? '',
        tagsRaw: m['tagsRaw'] as String? ?? '',
        updatedAtMs: (m['updatedAtMs'] as num).toInt(),
        imagesJson: m['imagesJson'] as String? ?? '[]',
      );
    } catch (_) {
      return null;
    }
  }
}

/// 标签语义一致（忽略顺序与大小写、逗号旁空格）。
bool composeDraftTagsEqual(String a, String b) {
  List<String> norm(String s) {
    final parts = s.split(',');
    final out = <String>[];
    for (final p in parts) {
      final t = p.trim();
      if (t.isNotEmpty) out.add(t.toLowerCase());
    }
    out.sort();
    return out;
  }

  final la = norm(a);
  final lb = norm(b);
  if (la.length != lb.length) return false;
  for (var i = 0; i < la.length; i++) {
    if (la[i] != lb[i]) return false;
  }
  return true;
}

/// 草稿是否与当前「正式基线」（库中已保存内容）一致。
bool composeDraftMatchesBaseline(
  ComposeDraft d,
  String baselineTitle,
  String baselineContent,
  String baselineTagsRaw,
  MoodKind baselineMood,
  String baselineImagesJson,
) {
  return d.title == baselineTitle &&
      d.content == baselineContent &&
      d.moodIndex == baselineMood.storageIndex &&
      composeDraftTagsEqual(d.tagsRaw, baselineTagsRaw) &&
      d.imagesJson == baselineImagesJson;
}
