import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/theme/app_tokens.dart';
import '../core/theme/mood_accent.dart';
import '../models/journal_entry.dart';
import '../models/mood_kind.dart';
import 'app_card.dart';
import 'mood_pill.dart';

/// 首页 / 回顾通用：白底卡片 + 左侧情绪细条。
class JournalEntryCard extends StatelessWidget {
  const JournalEntryCard({
    super.key,
    required this.entry,
    required this.onTap,
    this.compact = false,
    this.onTagTap,
  });

  final JournalEntry entry;
  final VoidCallback onTap;
  final bool compact;
  final ValueChanged<String>? onTagTap;

  @override
  Widget build(BuildContext context) {
    final mood = MoodKind.fromIndex(entry.moodIndex);
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final df = DateFormat('yyyy-MM-dd HH:mm');

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: mood.accentColor.withValues(alpha: 0.75),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadii.cardLarge - 1),
                  bottomLeft: Radius.circular(AppRadii.cardLarge - 1),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  compact ? 12 : 14,
                  compact ? 12 : 14,
                  compact ? 12 : 14,
                  compact ? 12 : 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MoodPill(mood: mood, compact: true),
                              if (entry.hasImages) ...[
                                const SizedBox(width: 8),
                                Tooltip(
                                  message: '含图片',
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 17,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Text(
                          df.format(entry.createdAt),
                          style: AppTypography.micro(tt).copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (entry.title.isNotEmpty) ...[
                      SizedBox(height: compact ? 6 : 8),
                      Text(
                        entry.title,
                        maxLines: compact ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.cardTitle(tt).copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                    ],
                    SizedBox(height: compact ? 8 : 10),
                    Text(
                      entry.content,
                      maxLines: compact ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.body(tt).copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.92),
                      ),
                    ),
                    if (entry.tags.isNotEmpty) ...[
                      SizedBox(height: compact ? 8 : 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: entry.tags.map((t) {
                          final box = Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: scheme.outline.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Text(
                              t,
                              style: AppTypography.micro(tt).copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          );
                          if (onTagTap == null) return box;
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => onTagTap!(t),
                              borderRadius: BorderRadius.circular(8),
                              child: box,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
