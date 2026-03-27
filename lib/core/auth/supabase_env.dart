/// Supabase 项目配置（勿把真实 Key 提交到公开仓库）。
///
/// 本地 / 发布构建时传入，例如：
/// ```text
/// flutter run --dart-define=SUPABASE_URL=https://xxxx.supabase.co ^
///   --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
/// ```
///
/// 未配置时云端账号功能关闭，本地日记仍正常使用。
class SupabaseEnv {
  SupabaseEnv._();

  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  static bool get isConfigured =>
      url.trim().isNotEmpty && anonKey.trim().isNotEmpty;
}
