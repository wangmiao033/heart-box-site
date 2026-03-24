import 'package:flutter_test/flutter_test.dart';
import 'package:heart_box_app/models/mood_kind.dart';

void main() {
  test('MoodKind.fromIndex 回退到平静', () {
    expect(MoodKind.fromIndex(0), MoodKind.calm);
    expect(MoodKind.fromIndex(999), MoodKind.calm);
  });
}
