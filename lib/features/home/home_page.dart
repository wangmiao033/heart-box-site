import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/journal_repository.dart';
import '../../features/journal/journal_controller.dart';
import '../../models/journal_entry.dart';
import '../../features/review/review_memory_widgets.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_search_bar.dart';
import '../../widgets/app_section_header.dart';
import '../../widgets/journal_entry_card.dart';
import 'home_ui_sections.dart';

/// 首页：治愈系主视觉 + 最近记录（壳层提供 Scaffold）。
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _searchCtrl;

  List<JournalEntry> _sameMonthDay = [];
  JournalEntry? _randomMemory;
  bool _memoryLoading = true;

  static final _pagePadding = EdgeInsets.fromLTRB(
    AppInsets.pageH,
    AppSpacing.s20,
    AppInsets.pageH,
    AppLayout.shellHomeBottomPadding,
  );

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return '早上好';
    if (h < 18) return '下午好';
    return '晚上好';
  }

  @override
  void initState() {
    super.initState();
    final jc = context.read<JournalController>();
    _searchCtrl = TextEditingController(text: jc.searchQuery);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMemoryPeek());
  }

  Future<void> _loadMemoryPeek() async {
    if (!mounted) return;
    setState(() => _memoryLoading = true);
    try {
      final repo = context.read<JournalRepository>();
      final now = DateTime.now();
      final same = await repo.listOnSameMonthDayExcludingCurrentYear(now);
      if (!mounted) return;
      if (same.isNotEmpty) {
        setState(() {
          _sameMonthDay = same;
          _randomMemory = null;
          _memoryLoading = false;
        });
      } else {
        final r = await repo.pickRandomEntry();
        if (!mounted) return;
        setState(() {
          _sameMonthDay = [];
          _randomMemory = r;
          _memoryLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _sameMonthDay = [];
          _randomMemory = null;
          _memoryLoading = false;
        });
      }
    }
  }

  Future<void> _shuffleHomeRandom() async {
    final repo = context.read<JournalRepository>();
    final next = await repo.pickRandomEntry(avoidId: _randomMemory?.id);
    if (!mounted) return;
    setState(() => _randomMemory = next);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyTagFilter(BuildContext context, String tag) {
    context.read<JournalController>().setFilterTag(tag);
  }

  void _openCompose() {
    context.push('/compose');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final df = DateFormat('M月d日 EEEE', 'zh_CN');

    return Consumer<JournalController>(
      builder: (context, journal, _) {
        final hasFilter = journal.filterTag != null ||
            journal.searchQuery.trim().isNotEmpty;

        return RefreshIndicator(
          color: scheme.primary,
          onRefresh: () async {
            await journal.refresh();
            await _loadMemoryPeek();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: _pagePadding,
            children: [
              HomeGreetingSection(
                greeting: _greeting(),
                dateLine: df.format(DateTime.now()),
                tagline: '把今天的情绪，轻轻放进匣子里。',
              ),
              SizedBox(height: AppSpacing.s24),
              HomeComposeHeroCard(onWrite: _openCompose),
              SizedBox(height: AppSpacing.s28),
              AppSectionHeader(
                title: '轻轻翻开',
                subtitle: '从这里去日历、回顾，或再翻一页旧心情',
              ),
              HomeQuickActionsRow(
                actions: [
                  HomeQuickActionData(
                    title: '今日回顾',
                    subtitle: '去「回顾」看看统计与往年今日',
                    icon: Icons.auto_graph_rounded,
                    onTap: () => context.go('/review'),
                  ),
                  HomeQuickActionData(
                    title: '翻一页旧心情',
                    subtitle: '随机遇见曾经的自己',
                    icon: Icons.shuffle_rounded,
                    onTap: () => context.go('/review'),
                  ),
                  HomeQuickActionData(
                    title: '日历上的脚印',
                    subtitle: '有记录的日子会被轻轻标出',
                    icon: Icons.calendar_month_rounded,
                    onTap: () => context.go('/calendar'),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.s24),
              AppSearchBar(
                controller: _searchCtrl,
                onChanged: journal.setSearchQuery,
              ),
              if (hasFilter) ...[
                const SizedBox(height: AppSpacing.s12),
                Material(
                  color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(AppRadii.card),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s12,
                      vertical: AppSpacing.s12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.filter_alt_outlined,
                          size: 20,
                          color: scheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '当前筛选',
                                style: tt.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: scheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.s8),
                              Wrap(
                                spacing: AppSpacing.s8,
                                runSpacing: AppSpacing.s8,
                                children: [
                                  if (journal.filterTag != null)
                                    Chip(
                                      avatar: Icon(
                                        Icons.label_outline_rounded,
                                        size: 18,
                                        color: scheme.primary,
                                      ),
                                      label: Text('标签：${journal.filterTag}'),
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  if (journal.searchQuery.trim().isNotEmpty)
                                    Chip(
                                      avatar: Icon(
                                        Icons.search_rounded,
                                        size: 18,
                                        color: scheme.primary,
                                      ),
                                      label: Text(
                                        '关键词：${journal.searchQuery.trim()}',
                                      ),
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            journal.clearFilters();
                            _searchCtrl.clear();
                          },
                          child: const Text('清除'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              SizedBox(height: AppSpacing.s28),
              AppSectionHeader(
                title: '今日拾光',
                subtitle: '往年的今天，或随机一页温柔往事',
              ),
              SizedBox(height: AppSpacing.s10),
              if (_memoryLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.s24),
                  child: Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else
                MemoryRecallCard(
                  moduleTitle:
                      _sameMonthDay.isNotEmpty ? '往年今日' : '随机回顾',
                  entry: _sameMonthDay.isNotEmpty
                      ? _sameMonthDay.first
                      : _randomMemory,
                  moreCount: _sameMonthDay.length > 1
                      ? _sameMonthDay.length - 1
                      : 0,
                  emptyTitle: '这里还没有可回看的记录',
                  emptySubtitle: '多写几条心事之后，我会为你悄悄留一页旧时光。',
                  onOpenDetail: () {
                    final e = _sameMonthDay.isNotEmpty
                        ? _sameMonthDay.first
                        : _randomMemory;
                    if (e != null) context.push('/entry/${e.id}');
                  },
                  onShuffle: _sameMonthDay.isEmpty ? _shuffleHomeRandom : null,
                  shuffleLabel: '换一页',
                  showShuffleWhenEmpty: false,
                ),
              SizedBox(height: AppSpacing.s28),
              AppSectionHeader(
                title: '最近写下的心事',
                subtitle: journal.entries.isEmpty
                    ? '今天还没有留下新的句子'
                    : '共 ${journal.entries.length} 条，都在这儿陪着你',
              ),
              if (journal.loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.s32),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (journal.error != null)
                AppEmptyState(
                  title: '加载时走散了',
                  subtitle: journal.error,
                  icon: Icons.error_outline_rounded,
                )
              else if (journal.entries.isEmpty)
                AppEmptyState(
                  title: !hasFilter ? '这里还没有内容' : '没有匹配的记录',
                  subtitle: !hasFilter
                      ? '点右下角「记一笔」，或从上方手记卡开始。'
                      : '试试清除筛选，或换一个温柔的词。',
                  icon: Icons.edit_note_rounded,
                  actionLabel: !hasFilter ? '记一笔' : null,
                  onAction: !hasFilter ? _openCompose : null,
                )
              else
                ...journal.entries.take(3).map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                        child: JournalEntryCard(
                          entry: e,
                          onTap: () => context.push('/entry/${e.id}'),
                          onTagTap: (t) => _applyTagFilter(context, t),
                        ),
                      ),
                    ),
              if (journal.entries.length > 3) ...[
                const SizedBox(height: AppSpacing.s8),
                Text(
                  '还有 ${journal.entries.length - 3} 条，在列表中继续翻阅',
                  style: tt.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
