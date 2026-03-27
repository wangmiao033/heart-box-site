import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import '../../models/journal_image_ref.dart';
import 'journal_image_persistence_io.dart'
    if (dart.library.html) 'journal_image_persistence_web.dart' as pers;

/// 日记图片：压缩为 JPEG、落盘（或 Web 行内），读写与删除。
class JournalImageStore {
  static Uint8List processToJpegBytes(Uint8List raw) {
    final decoded = img.decodeImage(raw);
    if (decoded == null) {
      throw const FormatException('无法识别图片格式');
    }
    var im = decoded;
    const maxSide = 1280;
    if (im.width > maxSide || im.height > maxSide) {
      if (im.width >= im.height) {
        im = img.copyResize(im, width: maxSide);
      } else {
        im = img.copyResize(im, height: maxSide);
      }
    }
    return Uint8List.fromList(img.encodeJpg(im, quality: 85));
  }

  Future<JournalImageRef> importXFile(XFile file) async {
    final raw = await file.readAsBytes();
    final jpeg = processToJpegBytes(raw);
    return pers.persistJpeg(jpeg);
  }

  Future<Uint8List?> bytesFor(JournalImageRef r) => pers.loadBytes(r);

  Future<void> deleteRef(JournalImageRef r) => pers.deleteRef(r);

  Future<void> deleteRefs(Iterable<JournalImageRef> refs) async {
    for (final r in refs) {
      await deleteRef(r);
    }
  }
}
