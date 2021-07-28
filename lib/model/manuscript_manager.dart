import 'package:flutter/cupertino.dart';
import 'package:presc/model/utils/database_helper.dart';
import 'package:presc/model/utils/database_table.dart';

class ManuscriptManager {
  final _dbHelper = DatabaseHelper.instance;

  Future<void> insert({String title = "", String content = ""}) async {
    DatabaseTable table = MemoTable(
      id: await _dbHelper.queryMaxId(MemoTable.name) + 1,
      title: title,
      content: content,
      date: DateTime.now(),
    );
    final id = await _dbHelper.insert(table);
    print('inserted row id: $id');
  }

  Future<void> update({@required int id, String title, String content}) async {
    DatabaseTable table = MemoTable(
      id: id,
      title: title,
      content: content,
      date: DateTime.now(),
    );
    await _dbHelper.update(table);
  }

  Future<List<MemoTable>> queryAll() async {
    final res = await _dbHelper.queryAllRows(MemoTable.name);
    List<MemoTable> tableList = res.map((row) => MemoTable.fromMap(row)).toList();
    print(tableList.first.toMap());
    return tableList;
  }
}
