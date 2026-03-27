import 'journal_image_ref.dart';
import 'mood_kind.dart';

class JournalEntry {
  JournalEntry({
    required this.id,
    this.title = '',
    required this.content,
    required this.moodIndex,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.images = const [],
    this.cloudId,
    this.cloudOwnerId,
    this.syncStatus = 'pending',
    this.lastSyncedAt,
  });

  final int id;
  /// 可选标题；空字符串表示未填。
  final String title;
  final String content;
  final int moodIndex;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  /// 本地图片附件（最多 [kMaxJournalImages] 条）。
  final List<JournalImageRef> images;

  final String? cloudId;
  final String? cloudOwnerId;
  final String syncStatus;
  final DateTime? lastSyncedAt;

  MoodKind get mood => MoodKind.fromIndex(moodIndex);

  bool get hasImages => images.isNotEmpty;

  /// 导出 JSON 用（与 DB 字段对应）。
  Map<String, dynamic> toExportMap() => {
        'id': id,
        'title': title,
        'content': content,
        'moodIndex': moodIndex,
        'moodLabel': mood.label,
        'tags': tags,
        'images': images.map((e) => e.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  JournalEntry copyWith({
    int? id,
    String? title,
    String? content,
    int? moodIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    List<JournalImageRef>? images,
    String? cloudId,
    String? cloudOwnerId,
    String? syncStatus,
    DateTime? lastSyncedAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      moodIndex: moodIndex ?? this.moodIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      images: images ?? this.images,
      cloudId: cloudId ?? this.cloudId,
      cloudOwnerId: cloudOwnerId ?? this.cloudOwnerId,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}
