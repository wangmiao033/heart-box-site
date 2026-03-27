import 'package:shared_preferences/shared_preferences.dart';

import 'compose_draft.dart';

/// 新建 / 编辑草稿分 key 持久化（SharedPreferences）。
class ComposeDraftStore {
  ComposeDraftStore._();
  static final ComposeDraftStore instance = ComposeDraftStore._();

  static const _keyNew = 'compose_draft_new';

  String _keyEdit(int id) => 'compose_draft_edit_$id';

  Future<ComposeDraft?> readNewDraft() async {
    final p = await SharedPreferences.getInstance();
    return ComposeDraft.fromStored(p.getString(_keyNew));
  }

  Future<void> writeNewDraft(ComposeDraft draft) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_keyNew, draft.toJsonString());
  }

  Future<void> clearNewDraft() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_keyNew);
  }

  Future<ComposeDraft?> readEditDraft(int entryId) async {
    final p = await SharedPreferences.getInstance();
    return ComposeDraft.fromStored(p.getString(_keyEdit(entryId)));
  }

  Future<void> writeEditDraft(int entryId, ComposeDraft draft) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_keyEdit(entryId), draft.toJsonString());
  }

  Future<void> clearEditDraft(int entryId) async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_keyEdit(entryId));
  }
}
