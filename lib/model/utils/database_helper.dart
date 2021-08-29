import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:path/path.dart';
import 'package:presc/config/sample_text_config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'database_table.dart';

class DatabaseHelper {
  static final _databaseName = "ManuscriptDatabase.db";
  static final _databaseVersion = 1;

  static DatabaseHelper _instance;
  static Database _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._();
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    // Test
    // await deleteDatabase(path);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _create);
  }

  Future _create(Database db, int version) async {
    await db.execute('''
          CREATE TABLE ${TagTable.name} (
            id INTEGER PRIMARY KEY,
            tag_name TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE ${MemoTable.name} (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            date TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE ${TagMemoTable.name} (
            memo_id INTEGER,
            tag_id INTEGER,
            FOREIGN KEY (memo_id) REFERENCES ${MemoTable.name}(id),
            FOREIGN KEY (tag_id) REFERENCES ${TagTable.name}(id)
          )
          ''');
    await db.execute('''
          CREATE TABLE ${TrashTable.name} (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            date TEXT NOT NULL
          )
          ''');
    _init(db);
  }

  Future<int> insert(DatabaseTable table) async {
    Database db = await _instance.database;
    return await db.insert(table.tableName, table.toMap());
  }

  Future<List<Map<String, dynamic>>> queryAll(String tableName) async {
    Database db = await _instance.database;
    return await db.query(tableName);
  }

  Future<Map<String, dynamic>> queryById(String tableName, int id) async {
    Database db = await _instance.database;
    final res = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return res.first;
  }

  Future<int> queryMaxId(String tableName, {String compareTableName}) async {
    Database db = await _instance.database;
    final res = await db.rawQuery('SELECT MAX(id) FROM $tableName');
    if (compareTableName == null) {
      return Sqflite.firstIntValue(res) ?? 0;
    } else {
      final res2 = await db.rawQuery('SELECT MAX(id) FROM $compareTableName');
      final list = [
        Sqflite.firstIntValue(res),
        Sqflite.firstIntValue(res2),
      ].whereNotNull().toList();
      return list.isNotEmpty ? list.reduce(max) : 0;
    }
  }

  Future<List<Map<String, dynamic>>> search(String keyword) async {
    Database db = await _instance.database;
    return await db.query(
      MemoTable.name,
      where: 'title LIKE ? or content LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
    );
  }

  Future<int> update(DatabaseTable table) async {
    Database db = await _instance.database;
    return await db.update(table.tableName, table.toMap(),
        where: 'id = ?', whereArgs: [table.id]);
  }

  Future<int> deleteAll(String tableName) async {
    Database db = await _instance.database;
    return await db.delete(tableName);
  }

  Future<int> delete(String tableName, int id, {String idName = "id"}) async {
    Database db = await _instance.database;
    return await db.delete(tableName, where: '$idName = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryTagByMemoId(int memoId) async {
    Database db = await _instance.database;
    final cross = TagMemoTable.name;
    final tag = TagTable.name;
    return await db.rawQuery('''
          SELECT $tag.id, $tag.tag_name
          FROM $cross INNER JOIN $tag ON $tag.id = $cross.tag_id
          WHERE $cross.memo_id = $memoId
          ''');
  }

  Future<List<Map<String, dynamic>>> queryMemoByTagId(int tagId) async {
    Database db = await _instance.database;
    final cross = TagMemoTable.name;
    final memo = MemoTable.name;
    return await db.rawQuery('''
          SELECT $memo.id, $memo.title, $memo.content, $memo.date
          FROM $cross INNER JOIN $memo ON $memo.id = $cross.memo_id
          WHERE $cross.tag_id = $tagId
          ''');
  }

  Future<void> execute(String sql, List<Object> arguments) async {
    Database db = await _instance.database;
    await db.execute(sql, arguments);
  }

  Future<void> _init(Database db) async {
    await Future.wait([
      db.insert(
        MemoTable.name,
        MemoTable(
          id: 1,
          title: SampleTextConfig.sampleTitle,
          content: SampleTextConfig.sampleContent,
          date: DateTime.now(),
        ).toMap(),
      ),
      db.insert(
        TagTable.name,
        TagTable(
          id: 1,
          tagName: "夏目漱石",
        ).toMap(),
      ),
      db.insert(
        TagTable.name,
        TagTable(
          id: 2,
          tagName: "練習用",
        ).toMap(),
      ),
      db.insert(
        TagMemoTable.name,
        TagMemoTable(
          memoId: 1,
          tagId: 1,
        ).toMap(),
      ),
    ]);
  }
}
