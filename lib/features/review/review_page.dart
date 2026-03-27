import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/journal_repository.dart';
import '../../features/journal/journal_controller.dart';
import '../../models/journal_entry.dart';
import '../../models/mood_kind.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_section_header.dart';
import '../../widgets/journal_entry_card.dart';
import '../../widgets/mood_pill.dart';
import 'review_memory_widgets.dart';

/// 回顾：总量、近 7 日、心情分布、趋势、标签与最近摘要。
class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  static final _pagePadding = EdgeInsets.fromLTRB(
    AppInsets.pageH,
    AppSpacing.s20,
    AppInsets.pageH,
    AppLayout.shellTabBottomPadding,
  );

  List<JournalEntry> _all = [];
  List<JournalEntry> _sameMonthEntries = [];
  JournalEntry? _randomEntry;
  bool _loading = true;
  String? _error;
  JournalController? _jc;
  MoodKind? _recentMoodFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _jc = context.read<JournalController>();
      _jc!.addListener(_reload);
      _reload();
    });
  }

  @override
  void dispose() {
    _jc?.removeListener(_reload);
    super.dispose();
  }

  Future<void> _reload() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = context.read<JournalRepository>();
      final list = await repo.listRecent();
      final same = await repo.listOnSameMonthDayExcludingCurrentYear(DateTime.now());
      final random = await repo.pickRandomEntry();
      if (mounted) {
        setState(() {
          _all = list;
          _sameMonthEntries = same;
          _randomEntry = random;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _shuffleRandomReview() async {
    final repo = context.read<JournalRepository>();
    final next = await repo.pickRandomEntry(avoidId: _randomEntry?.id);
    if (!mounted) return;
    setState(() => _randomEntry = next);
  }

  int _countLastDays(int days) {
    if (_all.isEmpty) return 0;
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day).subtract(Duration(days: days - 1));
    var n = 0;
    for (final e in _all) {
      final d = DateTime(e.createdAt.year, e.createdAt.month, e.createdAt.day);
      if (!d.isBefore(start)) n++;
    }
    return n;
  }

  Map<MoodKind, int> _moodCounts() {
    final m = <MoodKind, int>{for (final k in MoodKind.values) k: 0};
    for (final e in _all) {
      final mood = MoodKind.fromIndex(e.moodIndex);
      m[mood] = (m[mood] ?? 0) + 1;
    }
    return m;
  }

  /// 从「今天」往前共 7 个自然日，索引 0 = 最早一天。
  List<int> _trend7Counts() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day);
    final start = end.subtract(const Duration(days: 6));
    final counts = List.filled(7, 0);
    for (final e in _all) {
      final d = DateTime(e.createdAt.year, e.createdAt.month, e.createdAt.day);
      if (d.isBefore(start) || d.isAfter(end)) continue;
      final i = d.difference(start).inDays;
      if (i >= 0 && i < 7) counts[i]++;
    }
    return counts;
  }

  List<MapEntry<String, int>> _topTags({int limit = 12}) {
    final m = <String, int>{};
    for (final e in _all) {
      for (final t in e.tags) {
        m[t] = (m[t] ?? 0) + 1;
      }
    }
    final list = m.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (list.length <= limit) return list;
    return list.sublist(0, limit);
  }

  List<JournalEntry> _recentPreview() {
    Iterable<JournalEntry> pool = _all;
    if (_recentMoodFilter != null) {
      pool = pool.where((e) => MoodKind.fromIndex(e.moodIndex) == _recentMoodFilter);
    }
    return pool.take(8).toList();
  }

  Widget _moodRow(MoodKind mood, int count, int total, ColorScheme scheme) {
    final ratio = total == 0 ? 0.0 : count / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MoodPill(mood: mood, compact: true),
              Text(
                '$count 条',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }

  Widget _trendCard(ColorScheme scheme) {
    final counts = _trend7Counts();
    final maxC = counts.fold<int>(0, (a, b) => a > b ? a : b).clamp(1, 9999);
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day);
    final start = end.subtract(const Duration(days: 6));
    final df = DateFormat('M/d');

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '最近 7 天记录数',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 72,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final c = counts[i];
                final barH = 8.0 + (c / maxC) * 52.0;
                final day = start.add(Duration(days: i));
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '$c',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: scheme.primary,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          height: barH,
                          decoration: BoxDecoration(
                            color: scheme.primary.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          df.format(day),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontSize: 9,
                                color: scheme.onSurfaceVariant,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final total = _all.length;
    final last7 = _countLastDays(7);
    final moods = _moodCounts();
    final recent = _recentPreview();
    final topTags = _topTags();

    return ListView(
      padding: _pagePadding,
      children: [
        AppSectionHeader(
          title: '回顾',
          tone: AppSectionTone.hero,
          subtitle: '看看曾经的情绪，和一路走来的自己',
        ),
        if (_loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_error != null)
          AppEmptyState(
            title: '加载失败',
            subtitle: _error,
            icon: Icons.error_outline_rounded,
          )
        else ...[
          AppSectionHeader(
            title: '往年今日',
            subtitle: '历史上的今天（不含今天的公历日）',
          ),
          if (_sameMonthEntries.isEmpty)
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Text(
                '今天还没有往年记录',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            )
          else
            ..._sameMonthEntries.map(
              (e) => MemoryRecallListTile(
                entry: e,
                onTap: () => context.push('/entry/${e.id}'),
              ),
            ),
          const SizedBox(height: 20),
          AppSectionHeader(
            title: '翻一页旧心情',
            subtitle: '像从匣子里轻轻抽出一张旧卡片',
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            transitionBuilder: (child, anim) {
              return FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.04),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              );
            },
            child: MemoryRecallCard(
              key: ValueKey(_randomEntry?.id ?? -1),
              moduleTitle: '随机回顾',
              entry: _randomEntry,
              emptyTitle: total == 0 ? '这里还没有旧心情' : '暂时翻不到更多',
              emptySubtitle: total == 0
                  ? '写下第一条心事之后，再来抽一张旧卡片吧。'
                  : '试试再翻一页。',
              onOpenDetail: () {
                final e = _randomEntry;
                if (e != null) context.push('/entry/${e.id}');
              },
              onShuffle: total > 0 ? _shuffleRandomReview : null,
              shuffleLabel: '再翻一页',
            ),
          ),
          const SizedBox(height: 20),
          if (total == 0)
            AppEmptyState(
              title: '还没有足够的心事可以翻阅',
              subtitle: '多写几条之后，我会为你整理心情分布与最近拾光。',
              icon: Icons.auto_graph_outlined,
            )
          else ...[
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: _statTile(context, '全部记录', '$total', Icons.library_books_outlined),
                ),
                Container(width: 1, height: 44, color: scheme.outline.withValues(alpha: 0.25)),
                Expanded(
                  child: _statTile(context, '近 7 日', '$last7', Icons.date_range_rounded),
                ),
              ],
            ),
          ),
          if (_all.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s12),
            Text(
              '最近一次记录：${DateFormat('yyyy-MM-dd HH:mm').format(_all.first.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
          const SizedBox(height: 16),
          _trendCard(scheme),
          const SizedBox(height: 20),
          AppSectionHeader(
            title: '心情分布',
            subtitle: '各情绪档位占比（条数）',
          ),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final mood in MoodKind.values)
                  _moodRow(mood, moods[mood] ?? 0, total, scheme),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AppSectionHeader(
            title: '最常见标签',
            subtitle: '按出现次数排序（取前 12 个）',
          ),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: topTags.isEmpty
                ? Text(
                    '暂无标签',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: topTags
                        .map(
                          (e) => Chip(
                            avatar: CircleAvatar(
                              radius: 10,
                              backgroundColor: scheme.primaryContainer,
                              child: Text(
                                '${e.value}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: scheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            label: Text(e.key),
                          ),
                        )
                        .toList(),
                  ),
          ),
          const SizedBox(height: 20),
          AppSectionHeader(
            title: '最近记录摘要',
            subtitle: '按时间倒序，最多 8 条；可按心情筛选',
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('全部心情'),
                    selected: _recentMoodFilter == null,
                    onSelected: (_) => setState(() => _recentMoodFilter = null),
                  ),
                  const SizedBox(width: 8),
                  for (final m in MoodKind.values) ...[
                    FilterChip(
                      label: Text(m.label),
                      selected: _recentMoodFilter == m,
                      onSelected: (_) => setState(() => _recentMoodFilter = m),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
          ),
          if (recent.isEmpty)
            AppEmptyState(
              title: '该心情下暂无最近记录',
              subtitle: '换一个心情筛选试试。',
              icon: Icons.filter_alt_off_outlined,
            )
          else
            ...recent.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: JournalEntryCard(
                  entry: e,
                  compact: true,
                  onTap: () => context.push('/entry/${e.id}'),
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _statTile(BuildContext context, String label, String value, IconData icon) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, size: 26, color: scheme.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: tt.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: tt.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
