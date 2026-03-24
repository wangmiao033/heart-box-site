import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/journal_repository.dart';
import '../../models/journal_entry.dart';
import '../../models/mood_kind.dart';
import '../journal/journal_controller.dart';

class EntryDetailPage extends StatefulWidget {
  const EntryDetailPage({super.key, required this.entryId});

  final int entryId;

  @override
  State<EntryDetailPage> createState() => _EntryDetailPageState();
}

class _EntryDetailPageState extends State<EntryDetailPage> {
  Future<JournalEntry?>? _future;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _future = context.read<JournalRepository>().getById(widget.entryId);
      });
    });
  }

  void _reload() {
    setState(() {
      _future = context.read<JournalRepository>().getById(widget.entryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('yyyy-MM-dd HH:mm');
    final f = _future;

    if (f == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('记录')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return FutureBuilder<JournalEntry?>(
      future: f,
      builder: (context, snap) {
        if (!snap.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('记录')),
            body: snap.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : const Center(child: Text('记录不存在或已删除')),
          );
        }
        final e = snap.data!;
        final mood = MoodKind.fromIndex(e.moodIndex);
        return Scaffold(
          appBar: AppBar(
            title: const Text('记录详情'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () async {
                  await context.push('/compose?id=${e.id}');
                  if (context.mounted) {
                    await context.read<JournalController>().refresh();
                    _reload();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('删除记录'),
                      content: const Text('确定删除这条记录吗？此操作不可恢复。'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('取消'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('删除'),
                        ),
                      ],
                    ),
                  );
                  if (ok != true || !context.mounted) return;
                  await context.read<JournalRepository>().delete(e.id);
                  if (!context.mounted) return;
                  await context.read<JournalController>().refresh();
                  if (!context.mounted) return;
                  context.pop();
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  Icon(mood.icon),
                  const SizedBox(width: 8),
                  Text(
                    mood.label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Text(
                    df.format(e.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              if (e.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: e.tags.map((t) => Chip(label: Text(t))).toList(),
                ),
              ],
              const SizedBox(height: 20),
              SelectableText(
                e.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        );
      },
    );
  }
}
