import 'dart:async';

import '../../core/storage/journal_image_store.dart';
import '../../models/journal_image_ref.dart';

/// 删除日记后延迟清理附件，便于 SnackBar 撤销期间仍能从磁盘恢复文件引用。
class EntryDeleteImagePurge {
  EntryDeleteImagePurge._();

  static Timer? _timer;

  static void schedule(JournalImageStore store, List<JournalImageRef> refs) {
    _timer?.cancel();
    if (refs.isEmpty) return;
    final copy = List<JournalImageRef>.from(refs);
    _timer = Timer(const Duration(seconds: 5), () {
      store.deleteRefs(copy);
      _timer = null;
    });
  }

  static void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
