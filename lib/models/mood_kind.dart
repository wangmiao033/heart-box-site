import 'package:flutter/material.dart';

/// 心情档位，持久化为 [storageIndex]（与 Dart 枚举内置 [Enum.index] 区分）。
enum MoodKind {
  calm(0, '平静', Icons.spa_outlined),
  happy(1, '开心', Icons.sentiment_satisfied_alt_outlined),
  grateful(2, '感恩', Icons.favorite_outline),
  low(3, '低落', Icons.sentiment_dissatisfied_outlined),
  anxious(4, '焦虑', Icons.psychology_outlined),
  angry(5, '烦躁', Icons.mood_bad_outlined);

  const MoodKind(this.storageIndex, this.label, this.icon);

  /// 写入数据库的 mood_index。
  final int storageIndex;
  final String label;
  final IconData icon;

  static MoodKind fromIndex(int i) {
    return MoodKind.values.firstWhere(
      (m) => m.storageIndex == i,
      orElse: () => MoodKind.calm,
    );
  }
}
