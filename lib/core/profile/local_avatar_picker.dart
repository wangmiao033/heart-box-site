import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// 跨平台选取头像原始字节（Web 用 file_picker，避免 image_picker MissingPluginException）。
Future<Uint8List?> pickLocalAvatarImageBytes() async {
  if (kIsWeb) {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;
    final bytes = result.files.first.bytes;
    if (bytes == null || bytes.isEmpty) return null;
    return bytes;
  }

  final picker = ImagePicker();
  final xFile = await picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 1600,
    maxHeight: 1600,
    imageQuality: 92,
  );
  if (xFile == null) return null;
  return xFile.readAsBytes();
}
