import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../models/journal_image_ref.dart';

Future<JournalImageRef> persistJpeg(Uint8List jpeg) async {
  final dir = await getApplicationDocumentsDirectory();
  final folder = Directory(p.join(dir.path, 'journal_attachments'));
  if (!await folder.exists()) {
    await folder.create(recursive: true);
  }
  final name = '${DateTime.now().microsecondsSinceEpoch}_${jpeg.length}.jpg';
  final file = File(p.join(folder.path, name));
  await file.writeAsBytes(jpeg);
  return JournalImageRef.file(name);
}

Future<Uint8List?> loadBytes(JournalImageRef r) async {
  if (r.isInline) return r.inlineBytes;
  final name = r.fileName;
  if (name == null || name.isEmpty) return null;
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'journal_attachments', name));
  if (!await file.exists()) return null;
  return file.readAsBytes();
}

Future<void> deleteRef(JournalImageRef r) async {
  if (!r.isFile) return;
  final name = r.fileName;
  if (name == null || name.isEmpty) return;
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'journal_attachments', name));
  if (await file.exists()) {
    await file.delete();
  }
}
