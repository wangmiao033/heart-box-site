import 'package:flutter/foundation.dart';

import '../../data/journal_repository.dart';
import '../../models/journal_entry.dart';

class JournalController extends ChangeNotifier {
  JournalController(this._repo);

  final JournalRepository _repo;

  List<JournalEntry> entries = [];
  String searchQuery = '';
  bool loading = false;
  String? error;

  Future<void> refresh() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      entries = await _repo.listRecent(query: searchQuery);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String q) {
    if (searchQuery == q) return;
    searchQuery = q;
    notifyListeners();
    refresh();
  }

  Future<void> deleteEntry(int id) async {
    await _repo.delete(id);
    await refresh();
  }
}
