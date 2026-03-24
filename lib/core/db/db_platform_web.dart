import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// Web：必须注册 FFI Web 工厂，否则 openDatabase 会失败导致白屏。
Future<void> configureDatabaseForPlatform() async {
  databaseFactory = databaseFactoryFfiWeb;
}
