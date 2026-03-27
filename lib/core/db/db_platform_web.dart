import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// Web：必须注册 FFI Web 工厂，否则 openDatabase 会失败导致白屏。
///
/// 使用 [databaseFactoryFfiWebNoWebWorker]：只需站点根目录的 `sqlite3.wasm`（仓库 `web/sqlite3.wasm`），
/// 不必再生成 `sqflite_sw.js`（`dart run sqflite_common_ffi_web:setup` 在部分环境会失败）。
/// 缺点：多标签页不共享同一 DB 连接，本地/MVP 可接受。
Future<void> configureDatabaseForPlatform() async {
  databaseFactory = databaseFactoryFfiWebNoWebWorker;
}
