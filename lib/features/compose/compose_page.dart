import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/journal_repository.dart';
import '../../models/mood_kind.dart';
import '../journal/journal_controller.dart';
import '../../widgets/mood_picker.dart';
import '../../widgets/tag_input_bar.dart';

class ComposePage extends StatefulWidget {
  const ComposePage({super.key, this.entryId});

  /// 非空则为编辑已有记录。
  final int? entryId;

  @override
  State<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  final _content = TextEditingController();
  MoodKind _mood = MoodKind.calm;
  List<String> _tags = [];
  List<String> _suggestions = [];
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final repo = context.read<JournalRepository>();
    _suggestions = await repo.allTagNames();
    if (widget.entryId != null) {
      final e = await repo.getById(widget.entryId!);
      if (e != null && mounted) {
        _content.text = e.content;
        _mood = MoodKind.fromIndex(e.moodIndex);
        _tags = List<String>.from(e.tags);
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _content.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _content.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('写点什么再保存吧')),
      );
      return;
    }
    setState(() => _saving = true);
    final repo = context.read<JournalRepository>();
    try {
      if (widget.entryId == null) {
        await repo.insert(
          content: text,
          moodIndex: _mood.storageIndex,
          tagNames: _tags,
        );
      } else {
        await repo.update(
          id: widget.entryId!,
          content: text,
          moodIndex: _mood.storageIndex,
          tagNames: _tags,
        );
      }
      if (!mounted) return;
      await context.read<JournalController>().refresh();
      if (!mounted) return;
      context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.entryId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? '编辑记录' : '新建记录'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('保存'),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('心情', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                MoodPicker(value: _mood, onChanged: (m) => setState(() => _mood = m)),
                const SizedBox(height: 20),
                Text('标签', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                TagInputBar(
                  selected: _tags,
                  onChanged: (t) => setState(() => _tags = t),
                  suggestions: _suggestions,
                ),
                const SizedBox(height: 20),
                Text('内容', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                TextField(
                  controller: _content,
                  minLines: 8,
                  maxLines: 24,
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    hintText: '今天发生了什么？',
                  ),
                ),
              ],
            ),
    );
  }
}
