// 纯 Dart VM 自检（不经过 flutter test WebSocket harness）。
//   dart run tool/verify_models.dart
//
// 仅覆盖不依赖 dart:ui 的模型；MoodKind 等仍由 `dart analyze` / Web 手工测覆盖。

import 'dart:convert';

import 'package:heart_box_app/models/journal_image_ref.dart';

void main() {
  _run('JournalImageRef 编解码', () {
    final r = JournalImageRef.inline('image/jpeg', 'YQo=');
    final back = JournalImageRef.decodeList(JournalImageRef.encodeList([r]));
    if (back.length != 1 || back.first != r) {
      throw StateError('roundtrip');
    }
  });

  _run('JournalImageRef.decodeList 上限', () {
    final fiveMaps = List.generate(
      5,
      (i) => JournalImageRef.file('x$i.jpg').toJson(),
    );
    final back = JournalImageRef.decodeList(jsonEncode(fiveMaps));
    if (back.length != kMaxJournalImages) {
      throw StateError('expected cap $kMaxJournalImages, got ${back.length}');
    }
  });

  _run('JournalImageRef.listSequenceEqual', () {
    final a = [JournalImageRef.file('a.jpg')];
    final b = [JournalImageRef.file('a.jpg')];
    final c = [JournalImageRef.file('b.jpg')];
    if (!JournalImageRef.listSequenceEqual(a, b)) {
      throw StateError('a b');
    }
    if (JournalImageRef.listSequenceEqual(a, c)) {
      throw StateError('a c');
    }
  });

  // ignore: avoid_print
  print('verify_models: ok (JournalImageRef only)');
}

void _run(String name, void Function() fn) {
  try {
    fn();
  } catch (e, st) {
    // ignore: avoid_print
    print('verify_models FAIL — $name\n$e\n$st');
    rethrow;
  }
}
