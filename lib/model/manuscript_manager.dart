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

  Future<List<MemoTable>> getAllScript({trash = false}) async {
    final res = await _dbHelper.queryAll(trash ? TrashTable.name : MemoTable.name);
    List<MemoTable> tableList = res.map((row) => MemoTable.fromMap(row)).toList();
    return tableList;
  }

  Future<List<MemoTable>> getScriptByTagId({@required int tagId}) async {
    final res = await _dbHelper.queryMemoByTagId(tagId);
    List<MemoTable> tableList = res.map((row) => MemoTable.fromMap(row)).toList();
    return tableList;
  }

  Future<int> moveToTrash({@required int memoId}) async {
    await updateScript(id: memoId);
    final res = await _dbHelper.queryById(MemoTable.name, memoId);
    DatabaseTable table = TrashTable.fromMap(res);
    final id = await _dbHelper.insert(table);
    await _dbHelper.delete(MemoTable.name, memoId);
    print('deleted memo_table id: $memoId');
    return id;
  }

  Future<int> restoreFromTrash({@required int trashId}) async {
    final res = await _dbHelper.queryById(TrashTable.name, trashId);
    DatabaseTable table = MemoTable.fromMap(res);
    final id = await _dbHelper.insert(table);
    await _dbHelper.delete(TrashTable.name, trashId);
    print('restored memo_table id: $id');
    return id;
  }
}
