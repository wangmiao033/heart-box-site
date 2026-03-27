import 'dart:convert';
import 'dart:typed_data';

/// 每条日记最多附加图片数量。
const int kMaxJournalImages = 3;

/// 本地图片引用：移动端为文件名；Web 为行内 base64。
class JournalImageRef {
  const JournalImageRef._({
    required this.kind,
    this.fileName,
    this.mime,
    this.dataBase64,
  });

  /// `f` 文件 / `i` 行内
  final String kind;
  final String? fileName;
  final String? mime;
  final String? dataBase64;

  bool get isFile => kind == 'f';
  bool get isInline => kind == 'i';

  factory JournalImageRef.file(String name) {
    return JournalImageRef._(kind: 'f', fileName: name);
  }

  factory JournalImageRef.inline(String mime, String dataBase64) {
    return JournalImageRef._(kind: 'i', mime: mime, dataBase64: dataBase64);
  }

  Uint8List? get inlineBytes {
    if (!isInline || dataBase64 == null || dataBase64!.isEmpty) return null;
    try {
      return base64Decode(dataBase64!);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    if (isFile) {
      return {'k': 'f', 'n': fileName};
    }
    return {'k': 'i', 'm': mime ?? 'image/jpeg', 'd': dataBase64};
  }

  static JournalImageRef fromJson(Map<String, dynamic> json) {
    final k = json['k'] as String? ?? 'f';
    if (k == 'f') {
      return JournalImageRef.file(json['n'] as String? ?? '');
    }
    return JournalImageRef.inline(
      json['m'] as String? ?? 'image/jpeg',
      json['d'] as String? ?? '',
    );
  }

  static List<JournalImageRef> decodeList(String? column) {
    if (column == null || column.isEmpty || column == '[]') return [];
    try {
      final list = jsonDecode(column) as List<dynamic>;
      final out = <JournalImageRef>[];
      for (final e in list) {
        if (e is! Map) continue;
        out.add(fromJson(Map<String, dynamic>.from(e)));
        if (out.length >= kMaxJournalImages) break;
      }
      return out;
    } catch (_) {
      return [];
    }
  }

  static String encodeList(List<JournalImageRef> list) {
    final take = list.length > kMaxJournalImages
        ? list.sublist(0, kMaxJournalImages)
        : list;
    return jsonEncode(take.map((e) => e.toJson()).toList());
  }

  static bool listSequenceEqual(List<JournalImageRef> a, List<JournalImageRef> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  bool operator ==(Object other) {
    return other is JournalImageRef &&
        kind == other.kind &&
        fileName == other.fileName &&
        mime == other.mime &&
        dataBase64 == other.dataBase64;
  }

  @override
  int get hashCode => Object.hash(kind, fileName, mime, dataBase64);
}
