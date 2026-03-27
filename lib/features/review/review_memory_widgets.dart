import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/journal_entry.dart';
import '../../models/mood_kind.dart';
import '../../widgets/app_card.dart';
import '../../widgets/mood_pill.dart';

String memoryContentTeaser(String content, {int maxChars = 72}) {
  final t = content.trim();
  if (t.isEmpty) return '（无正文）';
  if (t.length <= maxChars) return t;
  return '${t.substring(0, maxChars)}…';
}

/// 首页 / 回顾：往年今日或随机回顾的轻量卡片。
class MemoryRecallCard extends StatelessWidget {
  const MemoryRecallCard({
    super.key,
    required this.moduleTitle,
    this.entry,
    this.moreCount = 0,
    required this.emptyTitle,
    this.emptySubtitle,
    required this.onOpenDetail,
    this.onShuffle,
    this.shuffleLabel = '换一条',
    this.detailLabel = '查看详情',
    this.showShuffleWhenEmpty = false,
  });

  final String moduleTitle;
  final JournalEntry? entry;
  /// 除当前展示外，同组还有几条（例如往年今日共 3 条时传 2）。
  final int moreCount;
  final String emptyTitle;
  final String? emptySubtitle;
  final VoidCallback onOpenDetail;
  final VoidCallback? onShuffle;
  final String shuffleLabel;
  final String detailLabel;
  final bool showShuffleWhenEmpty;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final hasEntry = entry != null;
    final df = DateFormat('yyyy-MM-dd HH:mm');

    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: hasEntry ? onOpenDetail : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.auto_stories_outlined, size: 20, color: scheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  moduleTitle,
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (onShuffle != null && (hasEntry || showShuffleWhenEmpty))
                TextButton(
                  onPressed: onShuffle,
                  child: Text(shuffleLabel),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (!hasEntry) ...[
            Text(
              emptyTitle,
              style: tt.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
            if (emptySubtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                emptySubtitle!,
                style: tt.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.9),
                ),
              ),
            ],
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MoodPill(mood: MoodKind.fromIndex(entry!.moodIndex), compact: true),
                if (entry!.hasImages) ...[
                  const SizedBox(width: 6),
                  Icon(
                    Icons.image_outlined,
                    size: 16,
                    color: scheme.onSurfaceVariant,
                  ),
                ],
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        df.format(entry!.createdAt),
                        style: tt.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (entry!.title.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          entry!.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: tt.titleSmall?.copyWith(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Text(
                        memoryContentTeaser(entry!.content),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: tt.bodySmall?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.88),
                          height: 1.35,
                        ),
                      ),
                      if (moreCount > 0) ...[
                        const SizedBox(height: 8),
                        Text(
                          '还有 $moreCount 条同日记念',
                          style: tt.labelSmall?.copyWith(
                            color: scheme.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonal(
                onPressed: onOpenDetail,
                child: Text(detailLabel),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 回顾页：往年今日列表中单条（紧凑）。
class MemoryRecallListTile extends StatelessWidget {
  const MemoryRecallListTile({
    super.key,
    required this.entry,
    required this.onTap,
  });

  final JournalEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final df = DateFormat('yyyy-MM-dd HH:mm');
    final mood = MoodKind.fromIndex(entry.moodIndex);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        padding: const EdgeInsets.all(12),
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 3,
              constraints: const BoxConstraints(minHeight: 48),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      MoodPill(mood: mood, compact: true),
                      if (entry.hasImages) ...[
                        const SizedBox(width: 6),
                        Icon(
                          Icons.image_outlined,
                          size: 16,
                          color: scheme.onSurfaceVariant,
                        ),
                      ],
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          df.format(entry.createdAt),
                          style: tt.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (entry.title.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      entry.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tt.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    memoryContentTeaser(entry.content, maxChars: 96),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodySmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
