import 'dart:convert';
import 'dart:typed_data';

import '../../models/journal_image_ref.dart';

Future<JournalImageRef> persistJpeg(Uint8List jpeg) async {
  return JournalImageRef.inline('image/jpeg', base64Encode(jpeg));
}

Future<Uint8List?> loadBytes(JournalImageRef r) async {
  if (!r.isInline) return null;
  return r.inlineBytes;
}

Future<void> deleteRef(JournalImageRef r) async {}
