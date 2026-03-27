import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/supabase_env.dart';
import '../../core/prefs/app_prefs.dart';
import '../../data/journal_repository.dart';
import '../../models/journal_entry.dart';
import '../auth/auth_controller.dart';
import '../journal/journal_controller.dart';
import 'sync_service.dart';
import 'sync_state.dart';

/// 云同步状态与触发全量同步；不往各业务页塞 UI。
class JournalSyncController extends ChangeNotifier {
  JournalSyncController({
    required bool supabaseReady,
    required JournalRepository repository,
    required JournalController journal,
    required AppPrefs prefs,
    required AuthController auth,
  })  : _repo = repository,
        _journal = journal,
        _prefs = prefs,
        _auth = auth,
        _ready = supabaseReady && SupabaseEnv.isConfigured {
    if (_ready) {
      _service = JournalSyncService(_repo, Supabase.instance.client);
      _authSub =
          Supabase.instance.client.auth.onAuthStateChange.listen((data) {
        switch (data.event) {
          case AuthChangeEvent.signedIn:
            unawaited(_runFullSyncInternal());
            break;
          case AuthChangeEvent.signedOut:
            _lastError = null;
            _syncing = false;
            _pendingCount = 0;
            notifyListeners();
            break;
          default:
            break;
        }
      });
      if (_auth.isLoggedIn) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          unawaited(_runFullSyncInternal());
        });
      }
    } else {
      _service = null;
    }
    unawaited(_refreshPendingCount());
  }

  final bool _ready;
  final JournalRepository _repo;
  final JournalController _journal;
  final AppPrefs _prefs;
  final AuthController _auth;
  JournalSyncService? _service;

  StreamSubscription<AuthState>? _authSub;
  Timer? _debounce;

  bool _syncing = false;
  String? _lastError;
  int _pendingCount = 0;
  bool _accountSwitchBanner = false;

  bool get isCloudSyncAvailable => _ready;

  bool get showAccountSwitchBanner => _accountSwitchBanner;

  String? get lastError => _lastError;

  int get pendingCount => _pendingCount;

  bool get isSyncing => _syncing;

  DateTime? get lastFullSyncAt {
    final ms = _prefs.lastJournalFullSyncAtMs;
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  JournalSyncUiStatus get uiStatus {
    if (!_ready || !_auth.isLoggedIn) {
      return JournalSyncUiStatus.unavailable;
    }
    if (_syncing) return JournalSyncUiStatus.syncing;
    if (_lastError != null) return JournalSyncUiStatus.failed;
    if (_pendingCount > 0) return JournalSyncUiStatus.pending;
    return JournalSyncUiStatus.synced;
  }

  void dismissAccountSwitchBanner() {
    _accountSwitchBanner = false;
    notifyListeners();
  }

  /// 本地增改后延迟全量同步，避免连点保存时频繁请求。
  void scheduleSyncDebounced() {
    if (_service == null || !_auth.isLoggedIn) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), () {
      unawaited(_runFullSyncInternal());
    });
  }

  /// 设置页「立即同步」。
  Future<void> syncNow() => _runFullSyncInternal();

  Future<void> _refreshPendingCount() async {
    final uid = _auth.currentUser?.id;
    if (uid == null || _service == null) {
      _pendingCount = 0;
    } else {
      _pendingCount = await _repo.countPendingForUser(uid);
    }
    notifyListeners();
  }

  Future<void> _runFullSyncInternal() async {
    if (_service == null || !_auth.isLoggedIn) return;
    final uid = _auth.currentUser!.id;
    _syncing = true;
    _lastError = null;
    notifyListeners();
    try {
      final prev = _prefs.lastCloudAccountId;
      if (prev != null && prev.isNotEmpty && prev != uid) {
        _accountSwitchBanner = true;
      }
      await _service!.runFullSync(
        userId: uid,
        onJournalChanged: () {
          unawaited(_journal.refresh());
        },
      );
      await _prefs.setLastCloudAccountId(uid);
      await _prefs.setLastJournalFullSyncAtMs(
        DateTime.now().millisecondsSinceEpoch,
      );
      _lastError = null;
    } catch (e) {
      _lastError = e.toString();
    } finally {
      _syncing = false;
      await _refreshPendingCount();
      notifyListeners();
    }
  }

  /// 本地硬删之前尝试云端软删。返回 false 表示云端删除失败，本地不应删。
  Future<bool> beforeLocalDelete(JournalEntry entry) async {
    if (_service == null || !_auth.isLoggedIn) return true;
    final uid = _auth.currentUser!.id;
    final cid = entry.cloudId;
    if (cid == null || cid.isEmpty) return true;
    if (entry.cloudOwnerId != null && entry.cloudOwnerId != uid) {
      return true;
    }
    try {
      await _service!.pushTombstone(userId: uid, cloudId: cid);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _authSub?.cancel();
    super.dispose();
  }
}
