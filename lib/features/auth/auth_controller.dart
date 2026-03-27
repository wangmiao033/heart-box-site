import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 封装 Supabase Auth；[supabaseReady] 为 false 时不访问 Supabase（未配置或初始化失败）。
class AuthController extends ChangeNotifier {
  AuthController({required bool supabaseReady}) : _ready = supabaseReady {
    if (_ready) {
      _authStateSub = Supabase.instance.client.auth.onAuthStateChange.listen(
        (_) => notifyListeners(),
      );
    }
  }

  final bool _ready;
  StreamSubscription<AuthState>? _authStateSub;

  bool get isCloudAuthAvailable => _ready;

  User? get currentUser => _ready ? Supabase.instance.client.auth.currentUser : null;

  bool get isLoggedIn => currentUser != null;

  String? get currentEmail => currentUser?.email;

  Session? get currentSession =>
      _ready ? Supabase.instance.client.auth.currentSession : null;

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (!_ready) {
      throw StateError('云端账号未配置');
    }
    return Supabase.instance.client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    if (!_ready) {
      throw StateError('云端账号未配置');
    }
    return Supabase.instance.client.auth.signUp(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() async {
    if (!_ready) return;
    await Supabase.instance.client.auth.signOut();
  }

  @override
  void dispose() {
    _authStateSub?.cancel();
    super.dispose();
  }
}

/// 将认证异常转为用户可读中文（保留原文后缀便于排查）。
String formatAuthError(Object error) {
  if (error is AuthException) {
    final m = error.message.trim();
    if (m.isEmpty) return '登录失败，请稍后再试';
    if (m.toLowerCase().contains('invalid login')) {
      return '邮箱或密码不正确';
    }
    if (m.toLowerCase().contains('email not confirmed')) {
      return '请先完成邮箱验证（查收邮件中的链接）';
    }
    if (m.toLowerCase().contains('user already registered')) {
      return '该邮箱已注册，请直接登录';
    }
    return m;
  }
  return error.toString();
}
