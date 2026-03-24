import 'mood_kind.dart';

class JournalEntry {
  JournalEntry({
    required this.id,
    required this.content,
    required this.moodIndex,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
  });

  final int id;
  final String content;
  final int moodIndex;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;

  MoodKind get mood => MoodKind.fromIndex(moodIndex);

  JournalEntry copyWith({
    int? id,
    String? content,
    int? moodIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      content: content ?? this.content,
      moodIndex: moodIndex ?? this.moodIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
    );
  }
}
