import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/storage/journal_image_store.dart';
import '../models/journal_entry.dart';
import '../models/journal_image_ref.dart';

/// 详情页：日记图片缩略图；无图不占位。
class JournalEntryImagesSection extends StatelessWidget {
  const JournalEntryImagesSection({super.key, required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    if (!entry.hasImages) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('图片', style: tt.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final ref in entry.images)
              _DetailThumb(
                imageRef: ref,
                onTap: (bytes) {
                  if (bytes != null) {
                    showJournalImageViewer(context, bytes);
                  }
                },
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '点击缩略图查看大图',
          style: tt.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _DetailThumb extends StatelessWidget {
  const _DetailThumb({
    required this.imageRef,
    required this.onTap,
  });

  final JournalImageRef imageRef;
  final void Function(Uint8List? bytes) onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final store = context.read<JournalImageStore>();

    return Material(
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          final b = await store.bytesFor(imageRef);
          onTap(b);
        },
        child: SizedBox(
          width: 96,
          height: 96,
          child: FutureBuilder<Uint8List?>(
            future: store.bytesFor(imageRef),
            builder: (context, snap) {
              final b = snap.data;
              if (b == null || b.isEmpty) {
                return ColoredBox(
                  color: scheme.surfaceContainerHighest,
                  child: Icon(Icons.broken_image_outlined,
                      color: scheme.onSurfaceVariant),
                );
              }
              return Image.memory(b, fit: BoxFit.cover, gaplessPlayback: true);
            },
          ),
        ),
      ),
    );
  }
}

void showJournalImageViewer(BuildContext context, Uint8List bytes) {
  showDialog<void>(
    context: context,
    builder: (ctx) => Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          InteractiveViewer(
            minScale: 0.5,
            maxScale: 4,
            child: Image.memory(bytes),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton.filledTonal(
              onPressed: () => Navigator.pop(ctx),
              icon: const Icon(Icons.close_rounded),
            ),
          ),
        ],
      ),
    ),
  );
}
