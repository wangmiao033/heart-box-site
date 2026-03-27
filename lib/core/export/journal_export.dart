import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/journal_entry.dart';
import 'journal_export_stub.dart'
    if (dart.library.html) 'journal_export_web.dart'
    if (dart.library.io) 'journal_export_io.dart' as platform;

/// 将全部记录导出为 JSON。Web 触发下载；移动端写入应用文档目录并返回路径。
Future<void> exportAllJournalsToJson(
  BuildContext context,
  List<JournalEntry> entries,
) async {
  final payload = <String, dynamic>{
    'app': 'heart_box_app',
    'exportedAt': DateTime.now().toIso8601String(),
    'entryCount': entries.length,
    'entries': entries.map((e) => e.toExportMap()).toList(),
  };
  final text = const JsonEncoder.withIndent('  ').convert(payload);
  final name =
      'heart_box_export_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json';

  if (kIsWeb) {
    platform.downloadJournalJson(name, text);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('已开始下载 JSON 文件'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    return;
  }

  final path = await platform.saveJournalJsonToDocuments(name, text);
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        path != null ? '已保存到：$path' : '导出失败，请检查存储权限',
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
