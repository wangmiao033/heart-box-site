import 'package:sqflite/sqflite.dart';

import 'heart_box_db_path.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = await resolveHeartBoxDbPath();
    return openDatabase(
      path,
      version: 4,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE entries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL DEFAULT '',
  content TEXT NOT NULL,
  mood_index INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  images_json TEXT NOT NULL DEFAULT '[]'
);
''');
        await db.execute('''
CREATE TABLE tags (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE COLLATE NOCASE
);
''');
        await db.execute('''
CREATE TABLE entry_tags (
  entry_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  PRIMARY KEY (entry_id, tag_id),
  FOREIGN KEY (entry_id) REFERENCES entries (id) ON DELETE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES tags (id) ON DELETE CASCADE
);
''');
        await db.execute(
          'CREATE INDEX idx_entries_created ON entries (created_at DESC);',
        );
        await db.execute(
          'CREATE INDEX idx_tags_name ON tags (name COLLATE NOCASE);',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            "ALTER TABLE entries ADD COLUMN title TEXT NOT NULL DEFAULT ''",
          );
        }
        if (oldVersion < 3) {
          await db.execute(
            "ALTER TABLE entries ADD COLUMN images_json TEXT NOT NULL DEFAULT '[]'",
          );
        }
        if (oldVersion < 4) {
          await db.execute(
            'ALTER TABLE entries ADD COLUMN cloud_id TEXT',
          );
          await db.execute(
            'ALTER TABLE entries ADD COLUMN cloud_owner_id TEXT',
          );
          await db.execute(
            "ALTER TABLE entries ADD COLUMN sync_status TEXT NOT NULL DEFAULT 'pending'",
          );
          await db.execute(
            'ALTER TABLE entries ADD COLUMN last_synced_at INTEGER',
          );
          await db.execute(
            'CREATE UNIQUE INDEX IF NOT EXISTS idx_entries_cloud_id '
            'ON entries (cloud_id) WHERE cloud_id IS NOT NULL',
          );
        }
      },
    );
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
