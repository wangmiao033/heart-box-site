import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../data/journal_repository.dart';
import '../../features/journal/journal_controller.dart';
import '../../models/journal_entry.dart';
import '../../widgets/app_empty_state.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../widgets/app_glass_card.dart';
import '../../widgets/app_section_header.dart';
import '../../widgets/journal_entry_card.dart';

/// 日历：按日查看记录（[TableCalendar] 固定高度，避免无约束 Stack）。
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  static final _pagePadding = EdgeInsets.fromLTRB(
    AppInsets.pageH,
    AppSpacing.s20,
    AppInsets.pageH,
    AppLayout.shellTabBottomPadding,
  );
  static const _calendarHeight = 380.0;

  late DateTime _focusedDay;
  late DateTime _selectedDay;
  Map<DateTime, int> _dayCounts = {};
  List<JournalEntry> _dayEntries = [];
  bool _loadingMarkers = true;
  bool _loadingDay = false;
  JournalController? _journalRef;
  bool _journalListening = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedDay = DateTime(now.year, now.month, now.day);
    _selectedDay = _focusedDay;
    WidgetsBinding.instance.addPostFrameCallback((_) => _attachAndLoad());
  }

  void _attachAndLoad() {
    if (!mounted) return;
    final jc = context.read<JournalController>();
    if (!_journalListening) {
      jc.addListener(_onJournalUpdate);
      _journalRef = jc;
      _journalListening = true;
    }
    _loadMarkers();
    _loadDayEntries();
  }

  void _onJournalUpdate() {
    _loadMarkers();
    _loadDayEntries();
  }

  Future<void> _loadMarkers() async {
    final repo = context.read<JournalRepository>();
    try {
      final map = await repo.entryCountsByDay();
      if (mounted) {
        setState(() {
          _dayCounts = map;
          _loadingMarkers = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingMarkers = false);
    }
  }

  Future<void> _loadDayEntries() async {
    setState(() => _loadingDay = true);
    final repo = context.read<JournalRepository>();
    try {
      final list = await repo.listForDay(_selectedDay);
      if (mounted) {
        setState(() {
          _dayEntries = list;
          _loadingDay = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingDay = false);
    }
  }

  @override
  void dispose() {
    if (_journalListening) {
      _journalRef?.removeListener(_onJournalUpdate);
    }
    super.dispose();
  }

  int _countOn(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    return _dayCounts[d] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dayLabel = DateFormat('M月d日', 'zh_CN').format(_selectedDay);
    final todayNorm = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final isTodaySelected = isSameDay(_selectedDay, todayNorm);

    return ListView(
      padding: _pagePadding,
      children: [
        AppSectionHeader(
          title: '日历',
          tone: AppSectionTone.hero,
          subtitle: '有记录的日子，会被轻轻标在时间里',
        ),
        const SizedBox(height: AppSpacing.s8),
        SizedBox(
          height: _calendarHeight,
          child: AppGlassCard(
            padding: const EdgeInsets.all(AppSpacing.s8),
            variant: AppGlassVariant.standard,
            child: _loadingMarkers
                  ? const Center(child: CircularProgressIndicator())
                  : TableCalendar<String>(
                      locale: 'zh_CN',
                      firstDay: DateTime.utc(2018, 1, 1),
                      lastDay: DateTime.utc(2035, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (d) => isSameDay(d, _selectedDay),
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      calendarFormat: CalendarFormat.month,
                      eventLoader: (day) {
                        final n = _countOn(day);
                        if (n <= 0) return const [];
                        return List<String>.filled(n, 'x');
                      },
                      onDaySelected: (selected, focused) {
                        setState(() {
                          _selectedDay = selected;
                          _focusedDay = focused;
                        });
                        _loadDayEntries();
                      },
                      onPageChanged: (focused) {
                        setState(() => _focusedDay = focused);
                      },
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, day, events) {
                          if (events.isEmpty) return const SizedBox.shrink();
                          final n = events.length;
                          return Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: scheme.primary,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$n',
                                style: TextStyle(
                                  fontSize: n > 9 ? 9 : 10,
                                  fontWeight: FontWeight.w800,
                                  color: scheme.onPrimary,
                                  height: 1,
                                ),
                              ),
                            ),
                          );
                        },
                        todayBuilder: (context, day, focusedDay) {
                          final isSel = isSameDay(day, _selectedDay);
                          if (isSel) return null;
                          if (!isSameDay(day, todayNorm)) return null;
                          return Container(
                            margin: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: scheme.primary, width: 2.2),
                              color: scheme.primaryContainer.withValues(alpha: 0.45),
                            ),
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color: scheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        },
                      ),
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        markersMaxCount: 99,
                        markerDecoration: const BoxDecoration(),
                        markersAlignment: Alignment.bottomRight,
                        todayDecoration: BoxDecoration(
                          color: scheme.primaryContainer.withValues(alpha: 0.35),
                          shape: BoxShape.circle,
                          border: Border.all(color: scheme.primary, width: 1.5),
                        ),
                        selectedDecoration: BoxDecoration(
                          color: scheme.primary,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: TextStyle(
                          color: scheme.onPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                        todayTextStyle: TextStyle(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurface,
                        ),
                        leftChevronIcon: Icon(Icons.chevron_left_rounded, color: scheme.onSurface),
                        rightChevronIcon: Icon(Icons.chevron_right_rounded, color: scheme.onSurface),
                      ),
                    ),
          ),
        ),
        if (!isTodaySelected)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedDay = todayNorm;
                    _focusedDay = todayNorm;
                  });
                  _loadDayEntries();
                },
                icon: const Icon(Icons.today_outlined, size: 18),
                label: const Text('回到今天'),
              ),
            ),
          ),
        const SizedBox(height: 12),
        AppSectionHeader(
          title: '$dayLabel 的记录',
          subtitle: _loadingDay ? '加载中…' : '${_dayEntries.length} 条',
        ),
        if (_loadingDay)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_dayEntries.isEmpty)
          AppEmptyState(
            title: '这一天还没有心事落下',
            subtitle: '选其它有小标记的日子，或去记一笔新的。',
            icon: Icons.nights_stay_outlined,
          )
        else
          ..._dayEntries.map(
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
    );
  }
}
