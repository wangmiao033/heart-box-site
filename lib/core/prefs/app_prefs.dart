import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_palette.dart';

/// 非敏感偏好：主题、锁开关、生物识别等。
class AppPrefs extends ChangeNotifier {
  AppPrefs._();
  static final AppPrefs instance = AppPrefs._();

  static const _themeMode = 'theme_mode';
  static const _appPalette = 'app_palette';
  static const _avatarJpegB64 = 'local_avatar_jpeg_b64';
  static const _lockEnabled = 'lock_enabled';
  static const _biometricEnabled = 'biometric_enabled';
  static const _lockOnResume = 'lock_on_resume';
  static const _lastCloudAccountId = 'last_cloud_account_id';
  static const _lastJournalFullSyncAtMs = 'last_journal_full_sync_ms';

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

  /// 配色主题（与 [themeMode] 的浅/深无关，只决定种子色）。
  AppPalette get appPalette {
    final raw = _p?.getString(_appPalette);
    return AppPaletteX.tryParse(raw) ?? AppPalette.classic;
  }

  Future<void> setAppPalette(AppPalette palette) async {
    final p = _p;
    if (p == null) return;
    await p.setString(_appPalette, palette.name);
    notifyListeners();
  }

  /// 本地头像（JPEG Base64），仅保存在本机偏好里，不参与同步与展示给访客。
  String? get localAvatarJpegBase64 => _p?.getString(_avatarJpegB64);

  Uint8List? get localAvatarJpegBytes {
    final s = localAvatarJpegBase64;
    if (s == null || s.isEmpty) return null;
    try {
      return base64Decode(s);
    } catch (_) {
      return null;
    }
  }

  Future<void> setLocalAvatarJpegBytes(Uint8List jpegBytes) async {
    final p = _p;
    if (p == null) return;
    final b64 = base64Encode(jpegBytes);
    await p.setString(_avatarJpegB64, b64);
    notifyListeners();
  }

  Future<void> clearLocalAvatar() async {
    final p = _p;
    if (p == null) return;
    await p.remove(_avatarJpegB64);
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

  /// 上次完成全量日记同步时登录的 Supabase `user.id`（用于检测换账号）。
  String? get lastCloudAccountId => _p?.getString(_lastCloudAccountId);

  Future<void> setLastCloudAccountId(String? v) async {
    final p = _p;
    if (p == null) return;
    if (v == null || v.isEmpty) {
      await p.remove(_lastCloudAccountId);
    } else {
      await p.setString(_lastCloudAccountId, v);
    }
    notifyListeners();
  }

  int? get lastJournalFullSyncAtMs =>
      _p?.getInt(_lastJournalFullSyncAtMs);

  Future<void> setLastJournalFullSyncAtMs(int ms) async {
    await _p?.setInt(_lastJournalFullSyncAtMs, ms);
    notifyListeners();
  }
}
