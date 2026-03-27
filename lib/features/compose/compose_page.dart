import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/journal_repository.dart';
import '../../models/journal_image_ref.dart';
import '../../models/mood_kind.dart';
import '../journal/journal_controller.dart';
import '../sync/sync_controller.dart';
import '../../core/storage/journal_image_store.dart';
import '../journal_support/journal_support_copy.dart';
import 'compose_draft.dart';
import 'compose_draft_store.dart';
import 'journal_compose_form.dart';

class ComposePage extends StatefulWidget {
  const ComposePage({super.key, this.entryId});

  /// 非空则为编辑已有记录。
  final int? entryId;

  @override
  State<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  static const _draftDebounceMs = 800;

  final _title = TextEditingController();
  final _content = TextEditingController();
  final _tagsRaw = TextEditingController();
  MoodKind _mood = MoodKind.calm;
  bool _loading = true;
  bool _saving = false;

  String _baselineTitle = '';
  String _baselineContent = '';
  String _baselineTags = '';
  MoodKind _baselineMood = MoodKind.calm;
  String _baselineImagesJson = '[]';
  List<JournalImageRef> _baselineImageRefs = [];
  List<JournalImageRef> _images = [];
  bool _baselineReady = false;

  final _draftStore = ComposeDraftStore.instance;
  Timer? _draftTimer;
  bool _draftListenersAttached = false;
  bool _draftSaveEnabled = false;
  String? _lastPersistedSignature;
  String? _draftStatusLine;
  bool _hadDraftPersist = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final repo = context.read<JournalRepository>();
    if (widget.entryId != null) {
      final e = await repo.getById(widget.entryId!);
      if (e != null && mounted) {
        _title.text = e.title;
        _content.text = e.content;
        _mood = MoodKind.fromIndex(e.moodIndex);
        _tagsRaw.text = e.tags.join(', ');
        _images = List<JournalImageRef>.from(e.images);
        _baselineImageRefs = List<JournalImageRef>.from(e.images);
        _baselineImagesJson = JournalImageRef.encodeList(e.images);
      }
    } else {
      _images = [];
      _baselineImageRefs = [];
      _baselineImagesJson = '[]';
    }
    if (!mounted) return;

    setState(() {
      _loading = false;
      _baselineTitle = _title.text;
      _baselineContent = _content.text;
      _baselineTags = _tagsRaw.text;
      _baselineMood = _mood;
      _baselineReady = true;
    });

    await _handleDraftRecovery();
    if (!mounted) return;

    _attachDraftListeners();
    setState(() => _draftSaveEnabled = true);
  }

  Future<void> _handleDraftRecovery() async {
    if (widget.entryId == null) {
      final stored = await _draftStore.readNewDraft();
      if (!mounted || stored == null || !stored.isMeaningful) return;

      final restore = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('发现上次未完成内容'),
          content: const Text('是否恢复上次的草稿？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('丢弃'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('恢复'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      if (restore == true) {
        _applyDraft(stored);
      } else {
        await _purgeRefsFromDraft(stored);
        await _draftStore.clearNewDraft();
        _lastPersistedSignature = null;
      }
      return;
    }

    final id = widget.entryId!;
    final stored = await _draftStore.readEditDraft(id);
    if (!mounted || stored == null || !stored.isMeaningful) return;

    if (composeDraftMatchesBaseline(
      stored,
      _baselineTitle,
      _baselineContent,
      _baselineTags,
      _baselineMood,
      _baselineImagesJson,
    )) {
      await _draftStore.clearEditDraft(id);
      _lastPersistedSignature = null;
      return;
    }

    final restore = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('发现这条记录有未完成修改'),
        content: const Text('是否恢复未保存的修改？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('使用当前正式内容'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('恢复修改'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (restore == true) {
      _applyDraft(stored);
    } else {
      await _purgeEditDraftOnlyOrphans(stored);
      await _draftStore.clearEditDraft(id);
      _lastPersistedSignature = null;
    }
  }

  Future<void> _purgeRefsFromDraft(ComposeDraft d) async {
    final refs = JournalImageRef.decodeList(d.imagesJson);
    if (refs.isEmpty) return;
    await context.read<JournalImageStore>().deleteRefs(refs);
  }

  /// 编辑草稿丢弃：只删草稿里多出来、尚未写入 DB 的文件引用。
  Future<void> _purgeEditDraftOnlyOrphans(ComposeDraft d) async {
    final draftRefs = JournalImageRef.decodeList(d.imagesJson);
    final orphan =
        draftRefs.where((r) => !_baselineImageRefs.contains(r)).toList();
    if (orphan.isEmpty) return;
    await context.read<JournalImageStore>().deleteRefs(orphan);
  }

  void _applyDraft(ComposeDraft d) {
    _title.text = d.title;
    _content.text = d.content;
    _tagsRaw.text = d.tagsRaw;
    _mood = MoodKind.fromIndex(d.moodIndex);
    _images = JournalImageRef.decodeList(d.imagesJson);
    setState(() {});
  }

  void _attachDraftListeners() {
    if (_draftListenersAttached) return;
    _draftListenersAttached = true;
    _title.addListener(_scheduleDraftDebouncedSave);
    _content.addListener(_scheduleDraftDebouncedSave);
    _tagsRaw.addListener(_scheduleDraftDebouncedSave);
  }

  void _scheduleDraftDebouncedSave() {
    if (!_draftSaveEnabled || _loading || !mounted) return;
    _draftTimer?.cancel();
    _draftTimer = Timer(
      const Duration(milliseconds: _draftDebounceMs),
      _flushDraftSave,
    );
  }

  ComposeDraft _draftFromForm() {
    return ComposeDraft(
      entryId: widget.entryId,
      moodIndex: _mood.storageIndex,
      title: _title.text,
      content: _content.text,
      tagsRaw: _tagsRaw.text,
      updatedAtMs: DateTime.now().millisecondsSinceEpoch,
      imagesJson: JournalImageRef.encodeList(_images),
    );
  }

  Future<void> _flushDraftSave() async {
    if (!mounted || !_draftSaveEnabled) return;

    final draft = _draftFromForm();
    final sig = draft.toJsonString();

    if (widget.entryId != null) {
      final id = widget.entryId!;
      if (composeDraftMatchesBaseline(
        draft,
        _baselineTitle,
        _baselineContent,
        _baselineTags,
        _baselineMood,
        _baselineImagesJson,
      )) {
        await _draftStore.clearEditDraft(id);
        _lastPersistedSignature = null;
        if (mounted) {
          setState(() {
            _draftStatusLine = null;
            _hadDraftPersist = false;
          });
        }
        return;
      }
      if (sig == _lastPersistedSignature) return;
      await _draftStore.writeEditDraft(id, draft);
    } else {
      if (!draft.isMeaningful) {
        await _draftStore.clearNewDraft();
        _lastPersistedSignature = null;
        if (mounted) {
          setState(() {
            _draftStatusLine = null;
            _hadDraftPersist = false;
          });
        }
        return;
      }
      if (sig == _lastPersistedSignature) return;
      await _draftStore.writeNewDraft(draft);
    }

    if (!mounted) return;
    _lastPersistedSignature = sig;
    setState(() {
      _draftStatusLine = _hadDraftPersist ? '草稿已更新' : '已自动保存草稿';
      _hadDraftPersist = true;
    });
  }

  Future<void> _clearCurrentDraftInStore() async {
    _draftTimer?.cancel();
    if (widget.entryId == null) {
      await _draftStore.clearNewDraft();
    } else {
      await _draftStore.clearEditDraft(widget.entryId!);
    }
    _lastPersistedSignature = null;
    if (mounted) {
      setState(() {
        _draftStatusLine = null;
        _hadDraftPersist = false;
      });
    }
  }

  bool get _isDirty {
    if (!_baselineReady || _loading) return false;
    return _title.text != _baselineTitle ||
        _content.text != _baselineContent ||
        _tagsRaw.text != _baselineTags ||
        _mood != _baselineMood ||
        !JournalImageRef.listSequenceEqual(_images, _baselineImageRefs);
  }

  Future<void> _deleteAbandonedNewImageRefs() async {
    final added = _images.where((r) => !_baselineImageRefs.contains(r)).toList();
    if (added.isEmpty) return;
    await context.read<JournalImageStore>().deleteRefs(added);
  }

  @override
  void dispose() {
    _draftTimer?.cancel();
    if (_draftListenersAttached) {
      _title.removeListener(_scheduleDraftDebouncedSave);
      _content.removeListener(_scheduleDraftDebouncedSave);
      _tagsRaw.removeListener(_scheduleDraftDebouncedSave);
    }
    _title.dispose();
    _content.dispose();
    _tagsRaw.dispose();
    super.dispose();
  }

  Future<void> _confirmLeave() async {
    final v = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('放弃编辑？'),
        content: const Text('当前内容尚未保存，确定要离开吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('继续编辑')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('离开')),
        ],
      ),
    );
    if (v == true && mounted) {
      await _deleteAbandonedNewImageRefs();
      await _clearCurrentDraftInStore();
      if (mounted) context.pop();
    }
  }

  Future<void> _save() async {
    final body = _content.text.trim();
    if (body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请先填写正文再保存'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _saving = true);
    final repo = context.read<JournalRepository>();
    final tags = parseCommaSeparatedTags(_tagsRaw.text);
    final title = _title.text.trim();
    final imgs = _images.length > kMaxJournalImages
        ? _images.sublist(0, kMaxJournalImages)
        : List<JournalImageRef>.from(_images);

    try {
      if (widget.entryId == null) {
        await repo.insert(
          title: title,
          content: body,
          moodIndex: _mood.storageIndex,
          tagNames: tags,
          images: imgs,
        );
      } else {
        await repo.update(
          id: widget.entryId!,
          title: title,
          content: body,
          moodIndex: _mood.storageIndex,
          tagNames: tags,
          images: imgs,
        );
      }
      if (!mounted) return;
      await context.read<JournalController>().refresh();
      if (!mounted) return;
      context.read<JournalSyncController>().scheduleSyncDebounced();

      await _clearCurrentDraftInStore();
      if (!mounted) return;

      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            pickComposeSaveMessage(
              isNew: widget.entryId == null,
              mood: _mood,
              random: Random(),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 2200),
        ),
      );
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.entryId != null;
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_saving) return;
        await _confirmLeave();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? '编辑记录' : '记一笔'),
          actions: [
            TextButton(
              onPressed: _saving || _loading ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('保存'),
            ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_draftStatusLine != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Text(
                        _draftStatusLine!,
                        style: tt.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  Expanded(
                    child: JournalComposeForm(
                      titleController: _title,
                      contentController: _content,
                      tagsController: _tagsRaw,
                      mood: _mood,
                      onMoodChanged: (m) {
                        setState(() => _mood = m);
                        _scheduleDraftDebouncedSave();
                      },
                      isEditing: isEdit,
                      imageRefs: _images,
                      onImageRefsChanged: (list) {
                        if (list.length > kMaxJournalImages) return;
                        setState(() => _images = list);
                        _scheduleDraftDebouncedSave();
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
