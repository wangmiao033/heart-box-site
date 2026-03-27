/// 与 pubspec.yaml version 对齐，用于「关于」展示。
abstract final class AppMeta {
  static const String version = '1.0.0';
  static const String build = '2';
  static String get versionLabel => '$version+$build';

  static const String tagline = '把今天的情绪，轻轻放进去。';
  static const String shortDescription =
      '心事匣是仅保存在本机的私密情绪日记，不社交、不上传，安静收纳每一天的心情。';
}
