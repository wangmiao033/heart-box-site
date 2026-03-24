import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 本地 PIN：仅存 SHA-256 摘要。
class PinStore {
  static const _keyHash = 'heart_box_pin_sha256';
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<bool> get hasPin async {
    final v = await _storage.read(key: _keyHash);
    return v != null && v.isNotEmpty;
  }

  Future<void> setPin(String pin) async {
    final hash = _hash(pin);
    await _storage.write(key: _keyHash, value: hash);
  }

  Future<void> clearPin() async {
    await _storage.delete(key: _keyHash);
  }

  Future<bool> verify(String pin) async {
    final stored = await _storage.read(key: _keyHash);
    if (stored == null) return false;
    return stored == _hash(pin);
  }

  String _hash(String pin) {
    final bytes = utf8.encode(pin);
    return sha256.convert(bytes).toString();
  }
}
