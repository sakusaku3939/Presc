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
    Database db = await instance.database;
    return await db.insert(table.tableName, table.toMap());
  }

  Future<List<Map<String, dynamic>>> queryAll(String tableName) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  Future<Map<String, dynamic>> queryById(String tableName, int id) async {
    Database db = await instance.database;
    final res = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return res.first;
  }

  Future<int> queryMaxId(String tableName) async {
    Database db = await instance.database;
    final res = await db.rawQuery('SELECT MAX(id) FROM $tableName');
    return Sqflite.firstIntValue(res) ?? 0;
  }

  Future<int> update(DatabaseTable table) async {
    Database db = await instance.database;
    return await db.update(table.tableName, table.toMap(),
        where: 'id = ?', whereArgs: [table.id]);
  }

  Future<int> delete(String tableName, int id) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryTagByMemoId(int memoId) async {
    Database db = await instance.database;
    final cross = TagMemoTable.name;
    final tag = TagTable.name;
    return await db.rawQuery('''
          SELECT $tag.id, $tag.tag_name
          FROM $cross INNER JOIN $tag ON $tag.id = $cross.tag_id
          WHERE $cross.memo_id = $memoId
          ''');
  }

  Future<List<Map<String, dynamic>>> queryMemoByTagId(int tagId) async {
    Database db = await instance.database;
    final cross = TagMemoTable.name;
    final memo = MemoTable.name;
    return await db.rawQuery('''
          SELECT $memo.id, $memo.title, $memo.content, $memo.date
          FROM $cross INNER JOIN $memo ON $memo.id = $cross.memo_id
          WHERE $cross.tag_id = $tagId
          ''');
  }

  Future<void> execute(String sql, List<Object> arguments) async {
    Database db = await instance.database;
    await db.execute(sql, arguments);
  }

  Future<void> _init(Database db) async {
    await Future.wait([
      db.insert(
        MemoTable.name,
        MemoTable(
          id: 1,
          title: "原稿1",
          content: "吾輩は猫である。名前はまだ無い。\n"
              "どこで生れたかとんと見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。この書生というのは時々我々を捕えて煮て食うという話である。しかしその当時は何という考もなかったから別段恐しいとも思わなかった。ただ彼の掌に載せられてスーと持ち上げられた時何だかフワフワした感じがあったばかりである。\n"
              "\n"
              "ようやくの思いで笹原を這い出すと向うに大きな池がある。吾輩は池の前に坐ってどうしたらよかろうと考えて見た。別にこれという分別も出ない。しばらくして泣いたら書生がまた迎に来てくれるかと考え付いた。ニャー、ニャーと試みにやって見たが誰も来ない。そのうち池の上をさらさらと風が渡って日が暮れかかる。腹が非常に減って来た。泣きたくても声が出ない。仕方がない、何でもよいから食物のある所まであるこうと決心をしてそろりそろりと池を左りに廻り始めた。どうも非常に苦しい。そこを我慢して無理やりに這って行くとようやくの事で何となく人間臭い所へ出た。",
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
