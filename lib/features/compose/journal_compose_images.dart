import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/storage/journal_image_store.dart';
import '../../models/journal_image_ref.dart';

/// 记一笔：正文附近图片区（最多 [kMaxJournalImages] 张）。
class JournalComposeImageStrip extends StatefulWidget {
  const JournalComposeImageStrip({
    super.key,
    required this.images,
    required this.onChanged,
  });

  final List<JournalImageRef> images;
  final ValueChanged<List<JournalImageRef>> onChanged;

  @override
  State<JournalComposeImageStrip> createState() =>
      _JournalComposeImageStripState();
}

class _JournalComposeImageStripState extends State<JournalComposeImageStrip> {
  final _picker = ImagePicker();
  final Map<JournalImageRef, Future<Uint8List?>> _thumbFutures = {};

  @override
  void didUpdateWidget(JournalComposeImageStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    final keys = widget.images.toSet();
    _thumbFutures.removeWhere((k, _) => !keys.contains(k));
  }

  Future<Uint8List?> _loadThumb(JournalImageRef ref) {
    return _thumbFutures.putIfAbsent(ref, () async {
      final store = context.read<JournalImageStore>();
      return store.bytesFor(ref);
    });
  }

  Future<void> _addImage() async {
    if (widget.images.length >= kMaxJournalImages) return;
    try {
      final x = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (x == null || !mounted) return;
      final store = context.read<JournalImageStore>();
      final ref = await store.importXFile(x);
      if (!mounted) return;
      final next = [...widget.images, ref];
      if (next.length > kMaxJournalImages) return;
      widget.onChanged(next);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('无法添加图片：$e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _removeAt(int index) {
    final store = context.read<JournalImageStore>();
    final removed = widget.images[index];
    final next = List<JournalImageRef>.from(widget.images)..removeAt(index);
    widget.onChanged(next);
    unawaited(store.deleteRef(removed));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final canAdd = widget.images.length < kMaxJournalImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.image_outlined, size: 20, color: scheme.primary),
            const SizedBox(width: 8),
            Text('图片', style: tt.titleSmall),
            const SizedBox(width: 8),
            Text(
              '最多 $kMaxJournalImages 张',
              style: tt.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < widget.images.length; i++)
              _ThumbTile(
                futureBytes: _loadThumb(widget.images[i]),
                onRemove: () => _removeAt(i),
              ),
            if (canAdd)
              Material(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: _addImage,
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 88,
                    height: 88,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          color: scheme.primary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '添加图片',
                          style: tt.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ThumbTile extends StatelessWidget {
  const _ThumbTile({
    required this.futureBytes,
    required this.onRemove,
  });

  final Future<Uint8List?> futureBytes;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 88,
      height: 88,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FutureBuilder<Uint8List?>(
                future: futureBytes,
                builder: (context, snap) {
                  final b = snap.data;
                  if (b == null || b.isEmpty) {
                    return ColoredBox(
                      color: scheme.surfaceContainerHighest,
                      child: Center(
                        child: snap.connectionState == ConnectionState.waiting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(
                                Icons.broken_image_outlined,
                                color: scheme.onSurfaceVariant,
                              ),
                      ),
                    );
                  }
                  return Image.memory(
                    b,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: -6,
            right: -6,
            child: Material(
              color: scheme.errorContainer,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onRemove,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: scheme.onErrorContainer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
