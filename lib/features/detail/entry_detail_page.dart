import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/storage/journal_image_store.dart';
import '../../data/journal_repository.dart';
import '../../models/journal_entry.dart';
import '../../models/mood_kind.dart';
import '../../widgets/journal_entry_images.dart';
import '../../widgets/mood_pill.dart';
import '../journal/journal_controller.dart';
import '../sync/sync_controller.dart';
import 'entry_delete_image_purge.dart';

/// 最近一次删除（用于 SnackBar 撤销），全局单槽避免并发删除互相覆盖。
class _PendingUndoDelete {
  static JournalEntry? entry;
}

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

  Future<void> _confirmDelete(JournalEntry e) async {
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
    if (ok != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final repo = context.read<JournalRepository>();
    final journal = context.read<JournalController>();
    final imageStore = context.read<JournalImageStore>();

    final sync = context.read<JournalSyncController>();
    final cloudOk = await sync.beforeLocalDelete(e);
    if (!cloudOk) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text('云端删除未成功，记录仍保留。请检查网络后重试删除。'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    _PendingUndoDelete.entry = e;
    await repo.delete(e.id, purgeAttachments: false);
    EntryDeleteImagePurge.schedule(imageStore, e.images);
    if (!mounted) return;
    await journal.refresh();
    if (!mounted) return;

    final backup = _PendingUndoDelete.entry;
    context.pop();

    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        content: const Text('已删除这条记录。'),
        action: SnackBarAction(
          label: '撤销',
          onPressed: () async {
            final snap = _PendingUndoDelete.entry;
            if (snap == null) return;
            EntryDeleteImagePurge.cancel();
            await repo.insert(
              title: snap.title,
              content: snap.content,
              moodIndex: snap.moodIndex,
              tagNames: snap.tags,
              images: snap.images,
              createdAtMs: snap.createdAt.millisecondsSinceEpoch,
              updatedAtMs: snap.updatedAt.millisecondsSinceEpoch,
            );
            _PendingUndoDelete.entry = null;
            await journal.refresh();
          },
        ),
      ),
    );

    Future<void>.delayed(const Duration(seconds: 5), () {
      if (_PendingUndoDelete.entry == backup) {
        _PendingUndoDelete.entry = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('yyyy-MM-dd HH:mm');
    final tt = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
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
                tooltip: '编辑',
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
                tooltip: '删除',
                onPressed: () => _confirmDelete(e),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              MoodPill(mood: mood),
              const SizedBox(height: 16),
              if (e.title.isNotEmpty) ...[
                Text(
                  e.title,
                  style: tt.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                '创建时间：${df.format(e.createdAt)}',
                style: tt.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 4),
              Text(
                '更新时间：${df.format(e.updatedAt)}',
                style: tt.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
              if (e.tags.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('标签', style: tt.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: e.tags.map((t) {
                    return ActionChip(
                      label: Text(t),
                      onPressed: () {
                        context.read<JournalController>().setFilterTag(t);
                        context.go('/home');
                      },
                    );
                  }).toList(),
                ),
              ],
              if (e.hasImages) ...[
                const SizedBox(height: 20),
                JournalEntryImagesSection(entry: e),
              ],
              const SizedBox(height: 20),
              Text('正文', style: tt.titleSmall),
              const SizedBox(height: 8),
              SelectableText(
                e.content,
                style: tt.bodyLarge?.copyWith(height: 1.45),
              ),
            ],
          ),
        );
      },
    );
  }
}
