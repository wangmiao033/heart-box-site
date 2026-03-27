import 'package:flutter/foundation.dart';

import '../../data/journal_repository.dart';
import '../../models/journal_entry.dart';

class JournalController extends ChangeNotifier {
  JournalController(this._repo);

  final JournalRepository _repo;

  List<JournalEntry> entries = [];
  String searchQuery = '';
  /// 精确匹配标签名（不区分大小写），与 [searchQuery] 可同时生效。
  String? filterTag;
  bool loading = false;
  String? error;

  Future<void> refresh() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      entries = await _repo.listRecent(
        query: searchQuery,
        tagFilter: filterTag,
      );
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

  /// 设为 null 或空字符串则清除标签筛选。
  void setFilterTag(String? tag) {
    final t = tag?.trim();
    final next = (t == null || t.isEmpty) ? null : t;
    if (filterTag == next) return;
    filterTag = next;
    notifyListeners();
    refresh();
  }

  void clearFilters() {
    var changed = false;
    if (searchQuery.isNotEmpty) {
      searchQuery = '';
      changed = true;
    }
    if (filterTag != null) {
      filterTag = null;
      changed = true;
    }
    if (changed) {
      notifyListeners();
      refresh();
    }
  }

  Future<void> deleteEntry(int id) async {
    await _repo.delete(id);
    await refresh();
  }
}
