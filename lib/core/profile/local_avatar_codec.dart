import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// 将用户选取的图片压成适合 [SharedPreferences] 的 JPEG（仅本地头像用）。
Uint8List? encodeLocalAvatarJpeg(
  Uint8List raw, {
  int maxSide = 256,
  int quality = 82,
}) {
  final decoded = img.decodeImage(raw);
  if (decoded == null) return null;

  final img.Image resized;
  if (decoded.width <= maxSide && decoded.height <= maxSide) {
    resized = decoded;
  } else if (decoded.width >= decoded.height) {
    resized = img.copyResize(decoded, width: maxSide);
  } else {
    resized = img.copyResize(decoded, height: maxSide);
  }

  return Uint8List.fromList(img.encodeJpg(resized, quality: quality));
}
