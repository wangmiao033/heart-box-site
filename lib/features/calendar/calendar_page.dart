import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../data/journal_repository.dart';
import '../../models/journal_entry.dart';
import '../../models/mood_kind.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;
  Set<DateTime> _marked = {};
  List<JournalEntry> _dayEntries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _selected = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMarks());
  }

  Future<void> _loadMarks() async {
    final repo = context.read<JournalRepository>();
    final days = await repo.daysWithEntries();
    if (!mounted) return;
    setState(() {
      _marked = days;
      _loading = false;
    });
    if (_selected != null) {
      await _loadDay(_selected!);
    }
  }

  Future<void> _loadDay(DateTime day) async {
    final repo = context.read<JournalRepository>();
    final list = await repo.listForDay(day);
    if (!mounted) return;
    setState(() => _dayEntries = list);
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(title: const Text('日历')),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadMarks();
          if (_selected != null) await _loadDay(_selected!);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            if (_loading)
              const Center(child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ))
            else
              TableCalendar<void>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2035, 12, 31),
                focusedDay: _focused,
                locale: 'zh_CN',
                selectedDayPredicate: (d) =>
                    _selected != null && _sameDay(d, _selected!),
                onDaySelected: (selected, focused) {
                  setState(() {
                    _selected = selected;
                    _focused = focused;
                  });
                  _loadDay(selected);
                },
                onPageChanged: (focused) {
                  setState(() => _focused = focused);
                },
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                ),
                headerStyle: const HeaderStyle(formatButtonVisible: false),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    final key = DateTime(day.year, day.month, day.day);
                    final has = _marked.any((d) => _sameDay(d, key));
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Center(child: Text('${day.day}')),
                        if (has)
                          Positioned(
                            bottom: 6,
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    final scheme = Theme.of(context).colorScheme;
                    return Container(
                      margin: const EdgeInsets.all(6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${day.day}',
                        style: TextStyle(color: scheme.onPrimaryContainer),
                      ),
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {
                    final scheme = Theme.of(context).colorScheme;
                    return Container(
                      margin: const EdgeInsets.all(6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: scheme.primary, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: Text('${day.day}'),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              _selected == null ? '选择日期' : df.format(_selected!),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (_dayEntries.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    _selected == null ? '' : '这一天还没有记录',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              )
            else
              ..._dayEntries.map(
                (e) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Icon(MoodKind.fromIndex(e.moodIndex).icon),
                    title: Text(
                      e.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      MoodKind.fromIndex(e.moodIndex).label,
                    ),
                    onTap: () => context.push('/entry/${e.id}'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
