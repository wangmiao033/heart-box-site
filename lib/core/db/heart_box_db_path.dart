import 'heart_box_db_path_native.dart'
    if (dart.library.html) 'heart_box_db_path_web.dart' as db_path_impl;

Future<String> resolveHeartBoxDbPath() => db_path_impl.resolveHeartBoxDbPath();
