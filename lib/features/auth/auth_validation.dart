/// 邮箱格式（实用级校验，非 RFC 全集）。
bool isWellFormedEmail(String raw) {
  final s = raw.trim();
  if (s.isEmpty || s.length > 254) return false;
  return RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  ).hasMatch(s);
}

/// Supabase 默认密码最短约 6 位，与控制台策略一致时可再收紧。
const int kMinAccountPasswordLength = 6;

String? validateAccountPassword(String password) {
  if (password.length < kMinAccountPasswordLength) {
    return '密码至少 $kMinAccountPasswordLength 位';
  }
  return null;
}
