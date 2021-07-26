import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'database_table.dart';

class DatabaseHelper {
  static final _databaseName = "ManuscriptDatabase.db";
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    // Test
    await deleteDatabase(path);

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
          CREATE TABLE tag_${MemoTable.name} (
            memo_id INTEGER,
            tag_id INTEGER,
            FOREIGN KEY (memo_id) REFERENCES ${MemoTable.name}(id),
            FOREIGN KEY (tag_id) REFERENCES ${TagTable.name}(id)
          )
          ''');
    // await db.execute('''
    //       CREATE TABLE ${TrashTable.name} (
    //         id INTEGER PRIMARY KEY,
    //         tag_id INTEGER,
    //         title TEXT NOT NULL,
    //         content TEXT NOT NULL,
    //         date TEXT NOT NULL,
    //         FOREIGN KEY (tag_id) REFERENCES ${TagTable.name}(id)
    //       )
    //       ''');
  }

  Future<int> insert(DatabaseTable table) async {
    Database db = await instance.database;
    return await db.insert(table.tableName, table.toMap());
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  Future<int> queryRowCount(String tableName) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  Future<int> update(DatabaseTable table) async {
    Database db = await instance.database;
    print([table.id]);
    return await db.update(table.tableName, table.toMap(),
        where: 'id = ?', whereArgs: [table.id]);
  }

  Future<int> delete(String tableName, int id) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}