import 'package:flutter/material.dart';

/// 标签输入：展示已选芯片，输入后回车或按钮添加。
class TagInputBar extends StatefulWidget {
  const TagInputBar({
    super.key,
    required this.selected,
    required this.onChanged,
    this.suggestions = const [],
  });

  final List<String> selected;
  final ValueChanged<List<String>> onChanged;
  final List<String> suggestions;

  @override
  State<TagInputBar> createState() => _TagInputBarState();
}

class _TagInputBarState extends State<TagInputBar> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _add(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return;
    if (widget.selected.any((e) => e.toLowerCase() == t.toLowerCase())) {
      _controller.clear();
      return;
    }
    widget.onChanged([...widget.selected, t]);
    _controller.clear();
  }

  void _remove(String tag) {
    widget.onChanged(widget.selected.where((e) => e != tag).toList());
  }

  @override
  Widget build(BuildContext context) {
    final pool = widget.suggestions
        .where(
          (s) => !widget.selected.any((t) => t.toLowerCase() == s.toLowerCase()),
        )
        .take(12)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.selected.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.selected
                .map(
                  (t) => InputChip(
                    label: Text(t),
                    onDeleted: () => _remove(t),
                  ),
                )
                .toList(),
          ),
        if (widget.selected.isNotEmpty) const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: '添加标签',
                  hintText: '输入后点添加或按完成',
                ),
                onSubmitted: _add,
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              onPressed: () => _add(_controller.text),
              child: const Text('添加'),
            ),
          ],
        ),
        if (pool.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('常用', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: pool
                .map(
                  (s) => ActionChip(
                    label: Text(s),
                    onPressed: () => _add(s),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
