import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/journal_repository.dart';
import '../../models/journal_entry.dart';
import '../../models/mood_kind.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<JournalEntry> _entries = [];
  bool _loading = true;

  DateTime _startOfWeek(DateTime d) {
    final day = DateTime(d.year, d.month, d.day);
    return day.subtract(Duration(days: day.weekday - 1));
  }

  DateTime _endOfWeek(DateTime start) {
    return DateTime(start.year, start.month, start.day + 6, 23, 59, 59, 999);
  }

  Future<void> _load() async {
    final repo = context.read<JournalRepository>();
    final now = DateTime.now();
    final s = _startOfWeek(now);
    final e = _endOfWeek(s);
    final list = await repo.listBetween(s, e);
    if (!mounted) return;
    setState(() {
      _entries = list;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('MM-dd');
    final moodCounts = <MoodKind, int>{};
    for (final m in MoodKind.values) {
      moodCounts[m] = 0;
    }
    for (final e in _entries) {
      final m = MoodKind.fromIndex(e.moodIndex);
      moodCounts[m] = (moodCounts[m] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('回顾')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    '本周概览',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '共 ${_entries.length} 条记录',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '心情分布',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  ...MoodKind.values.map((m) {
                    final c = moodCounts[m] ?? 0;
                    if (c == 0) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Icon(m.icon, size: 20),
                          const SizedBox(width: 8),
                          SizedBox(width: 48, child: Text(m.label)),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: _entries.isEmpty
                                  ? 0
                                  : c / _entries.length,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('$c'),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  Text(
                    '本周记录',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  if (_entries.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: Text('本周还没有记录')),
                    )
                  else
                    ..._entries.map(
                      (e) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading:
                              Icon(MoodKind.fromIndex(e.moodIndex).icon),
                          title: Text(
                            e.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(df.format(e.createdAt)),
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
