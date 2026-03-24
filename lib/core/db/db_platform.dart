import 'db_platform_stub.dart'
    if (dart.library.html) 'db_platform_web.dart' as db_platform;

/// 在打开本地库之前调用（Web 与原生分支由条件导入处理）。
Future<void> configureDatabaseForPlatform() =>
    db_platform.configureDatabaseForPlatform();
