import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/journal_image_ref.dart';
import '../../models/mood_kind.dart';
import '../../widgets/mood_picker.dart';
import '../journal_support/journal_support_copy.dart';
import 'journal_compose_images.dart';

/// 新建 / 编辑共用表单（不含 Scaffold；由 [ComposePage] 包裹）。
class JournalComposeForm extends StatefulWidget {
  const JournalComposeForm({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.tagsController,
    required this.mood,
    required this.onMoodChanged,
    required this.isEditing,
    required this.imageRefs,
    required this.onImageRefsChanged,
  });

  final TextEditingController titleController;
  final TextEditingController contentController;
  final TextEditingController tagsController;
  final MoodKind mood;
  final ValueChanged<MoodKind> onMoodChanged;

  /// 编辑已有日记时为 true；新建为 false。
  final bool isEditing;

  final List<JournalImageRef> imageRefs;
  final ValueChanged<List<JournalImageRef>> onImageRefsChanged;

  @override
  State<JournalComposeForm> createState() => _JournalComposeFormState();
}

class _JournalComposeFormState extends State<JournalComposeForm> {
  static const int _promptCollapseChars = 80;

  late final FocusNode _contentFocus;
  late final Random _random;
  late String _promptText;
  bool _promptExpandedByUser = false;
  bool _comfortDismissed = false;

  bool get _showWritingPrompt =>
      !widget.isEditing || widget.contentController.text.trim().isEmpty;

  bool get _promptCompactMode =>
      _showWritingPrompt &&
      widget.contentController.text.length > _promptCollapseChars &&
      !_promptExpandedByUser;

  @override
  void initState() {
    super.initState();
    _contentFocus = FocusNode();
    _random = Random();
    _promptText = pickWritingPrompt(_random);
    widget.contentController.addListener(_onContentChanged);
  }

  @override
  void didUpdateWidget(JournalComposeForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mood != widget.mood) {
      _comfortDismissed = false;
    }
    if (oldWidget.contentController != widget.contentController) {
      oldWidget.contentController.removeListener(_onContentChanged);
      widget.contentController.addListener(_onContentChanged);
    }
  }

  void _onContentChanged() {
    final len = widget.contentController.text.length;
    if (len <= _promptCollapseChars && _promptExpandedByUser) {
      setState(() => _promptExpandedByUser = false);
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.contentController.removeListener(_onContentChanged);
    _contentFocus.dispose();
    super.dispose();
  }

  void _shufflePrompt() {
    setState(() {
      _promptText = pickWritingPrompt(_random, avoid: _promptText);
    });
  }

  void _insertPromptIntoContent() {
    final c = widget.contentController;
    final text = c.text;
    final sel = c.selection;
    final insert = _promptText;

    if (!sel.isValid || !sel.isNormalized) {
      if (text.isEmpty) {
        c.value = TextEditingValue(
          text: insert,
          selection: TextSelection.collapsed(offset: insert.length),
        );
      } else {
        final merged = '$insert\n$text';
        c.value = TextEditingValue(
          text: merged,
          selection: TextSelection.collapsed(offset: insert.length + 1),
        );
      }
      return;
    }

    final start = sel.start.clamp(0, text.length);
    final end = sel.end.clamp(0, text.length);
    final newText = text.replaceRange(start, end, insert);
    final newOffset = start + insert.length;
    c.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
    _contentFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final comfort = comfortForMood(widget.mood);
    final showComfort =
        moodNeedsComfort(widget.mood) && comfort != null && !_comfortDismissed;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('心情', style: tt.titleSmall),
        const SizedBox(height: 8),
        MoodPicker(value: widget.mood, onChanged: widget.onMoodChanged),
        if (showComfort) ...[
          const SizedBox(height: 16),
          _ComfortCard(
            copy: comfort,
            onContinue: () {
              setState(() => _comfortDismissed = true);
              _contentFocus.requestFocus();
            },
          ),
        ],
        const SizedBox(height: 20),
        Text('标题', style: tt.titleSmall),
        const SizedBox(height: 8),
        TextField(
          controller: widget.titleController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            hintText: '可选，简短概括今天',
          ),
        ),
        const SizedBox(height: 20),
        Text('标签', style: tt.titleSmall),
        const SizedBox(height: 8),
        TextField(
          controller: widget.tagsController,
          minLines: 1,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: '多个标签用英文逗号分隔，如：工作, 运动',
          ),
        ),
        const SizedBox(height: 20),
        if (_showWritingPrompt) ...[
          if (_promptCompactMode)
            _WritingPromptCompactBar(
              prompt: _promptText,
              onExpand: () => setState(() => _promptExpandedByUser = true),
              onShuffle: _shufflePrompt,
            )
          else
            _WritingPromptCard(
              prompt: _promptText,
              onShuffle: _shufflePrompt,
              onUseAsStart: _insertPromptIntoContent,
            ),
          const SizedBox(height: 20),
        ],
        Text('正文', style: tt.titleSmall),
        const SizedBox(height: 8),
        TextField(
          controller: widget.contentController,
          focusNode: _contentFocus,
          minLines: 8,
          maxLines: 24,
          decoration: const InputDecoration(
            alignLabelWithHint: true,
            hintText: '今天发生了什么？（必填）',
          ),
        ),
        const SizedBox(height: 16),
        JournalComposeImageStrip(
          images: widget.imageRefs,
          onChanged: widget.onImageRefsChanged,
        ),
      ],
    );
  }
}

class _WritingPromptCard extends StatelessWidget {
  const _WritingPromptCard({
    required this.prompt,
    required this.onShuffle,
    required this.onUseAsStart,
  });

  final String prompt;
  final VoidCallback onShuffle;
  final VoidCallback onUseAsStart;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.edit_note_outlined, size: 20, color: scheme.primary),
                const SizedBox(width: 8),
                Text('写作提示', style: tt.labelLarge),
              ],
            ),
            const SizedBox(height: 10),
            Text(prompt, style: tt.bodyMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: onShuffle,
                  child: const Text('换一个'),
                ),
                FilledButton.tonal(
                  onPressed: onUseAsStart,
                  child: const Text('用这个开头'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WritingPromptCompactBar extends StatelessWidget {
  const _WritingPromptCompactBar({
    required this.prompt,
    required this.onExpand,
    required this.onShuffle,
  });

  final String prompt;
  final VoidCallback onExpand;
  final VoidCallback onShuffle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onExpand,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.edit_note_outlined, size: 20, color: scheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '写作提示 · $prompt',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.bodySmall,
                ),
              ),
              TextButton(
                onPressed: onShuffle,
                child: const Text('换一个'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComfortCard extends StatelessWidget {
  const _ComfortCard({
    required this.copy,
    required this.onContinue,
  });

  final ComfortCopy copy;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: scheme.primaryContainer.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('给此刻的你', style: tt.labelLarge),
            const SizedBox(height: 10),
            Text(copy.line1, style: tt.bodyMedium),
            const SizedBox(height: 6),
            Text(copy.line2, style: tt.bodyMedium),
            const SizedBox(height: 10),
            Text(
              '建议：${copy.suggestion}',
              style: tt.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonal(
                onPressed: onContinue,
                child: const Text('继续写下去'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 将逗号分隔标签解析为去重、去空列表。
List<String> parseCommaSeparatedTags(String raw) {
  final out = <String>[];
  final seen = <String>{};
  for (final part in raw.split(',')) {
    final t = part.trim();
    if (t.isEmpty) continue;
    final key = t.toLowerCase();
    if (seen.add(key)) out.add(t);
  }
  return out;
}
