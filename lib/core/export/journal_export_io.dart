import 'dart:io';

import 'package:path_provider/path_provider.dart';

void downloadJournalJson(String filename, String jsonText) {
  throw UnsupportedError('Use saveJournalJsonToDocuments on IO');
}

Future<String?> saveJournalJsonToDocuments(String filename, String jsonText) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final f = File('${dir.path}/$filename');
    await f.writeAsString(jsonText, flush: true);
    return f.path;
  } catch (_) {
    return null;
  }
}
