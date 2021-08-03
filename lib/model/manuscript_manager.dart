import 'package:flutter/material.dart';
import 'package:presc/model/utils/database_helper.dart';
import 'package:presc/model/utils/database_table.dart';

class ManuscriptManager {
  final _dbHelper = DatabaseHelper.instance;

  Future<int> addScript({String title = "", String content = ""}) async {
    DatabaseTable table = MemoTable(
      id: await _dbHelper.queryMaxId(MemoTable.name) + 1,
      title: title,
      content: content,
      date: DateTime.now(),
    );
    final id = await _dbHelper.insert(table);
    print('inserted memo_table id: $id');
    return id;
  }

  Future<void> updateScript({@required int id, String title, String content}) async {
    DatabaseTable table = MemoTable(
      id: id,
      title: title,
      content: content,
      date: DateTime.now(),
    );
    await _dbHelper.update(table);
  }

  Future<List<MemoTable>> getAllScript() async {
    final res = await _dbHelper.queryAll(MemoTable.name);
    List<MemoTable> tableList = res.map((row) => MemoTable.fromMap(row)).toList();
    return tableList;
  }
}
