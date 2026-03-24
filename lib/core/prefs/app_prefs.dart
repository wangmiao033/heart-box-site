import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 非敏感偏好：主题、锁开关、生物识别等。
class AppPrefs extends ChangeNotifier {
  AppPrefs._();
  static final AppPrefs instance = AppPrefs._();

  static const _themeMode = 'theme_mode';
  static const _lockEnabled = 'lock_enabled';
  static const _biometricEnabled = 'biometric_enabled';
  static const _lockOnResume = 'lock_on_resume';

  SharedPreferences? _p;

  Future<void> load() async {
    _p = await SharedPreferences.getInstance();
    notifyListeners();
  }

  ThemeMode get themeMode {
    final v = _p?.getInt(_themeMode);
    return switch (v) {
      1 => ThemeMode.light,
      2 => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final p = _p;
    if (p == null) return;
    final v = switch (mode) {
      ThemeMode.light => 1,
      ThemeMode.dark => 2,
      _ => 0,
    };
    await p.setInt(_themeMode, v);
    notifyListeners();
  }

  bool get lockEnabled => _p?.getBool(_lockEnabled) ?? false;

  Future<void> setLockEnabled(bool v) async {
    await _p?.setBool(_lockEnabled, v);
    notifyListeners();
  }

  bool get biometricEnabled => _p?.getBool(_biometricEnabled) ?? false;

  Future<void> setBiometricEnabled(bool v) async {
    await _p?.setBool(_biometricEnabled, v);
    notifyListeners();
  }

  bool get lockOnResume => _p?.getBool(_lockOnResume) ?? true;

  Future<void> setLockOnResume(bool v) async {
    await _p?.setBool(_lockOnResume, v);
    notifyListeners();
  }
}
