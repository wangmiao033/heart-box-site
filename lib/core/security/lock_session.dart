import 'package:flutter/widgets.dart';

import '../prefs/app_prefs.dart';

/// 应用内解锁状态（与 [AppPrefs.lockEnabled] 配合）。
class LockSession extends ChangeNotifier with WidgetsBindingObserver {
  LockSession(this._prefs);

  final AppPrefs _prefs;
  bool _ready = false;
  bool _unlocked = false;

  bool get ready => _ready;
  bool get unlocked => _unlocked;

  /// 是否需要显示锁屏（已开启锁且当前未解锁）。
  bool get needsLock =>
      _ready && _prefs.lockEnabled && !_unlocked;

  /// 需先调用 [AppPrefs.load]。
  Future<void> bootstrap() async {
    WidgetsBinding.instance.addObserver(this);
    if (!_prefs.lockEnabled) {
      _unlocked = true;
    }
    _ready = true;
    notifyListeners();
  }

  void unlock() {
    _unlocked = true;
    notifyListeners();
  }

  void lockApp() {
    if (_prefs.lockEnabled) {
      _unlocked = false;
      notifyListeners();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (_prefs.lockOnResume && _prefs.lockEnabled) {
        _unlocked = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 关闭应用锁时同步清空会话锁状态。
  void onLockDisabled() {
    _unlocked = true;
    notifyListeners();
  }
}
