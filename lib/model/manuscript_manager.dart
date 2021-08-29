import 'package:flutter/material.dart';
import 'package:presc/model/utils/database_helper.dart';
import 'package:presc/model/utils/database_table.dart';

class ManuscriptManager {
  final _helper = DatabaseHelper();

  Future<int> addScript({String title = "", String content = ""}) async {
    final maxId = await _helper.queryMaxId(
      MemoTable.name,
      compareTableName: TrashTable.name,
    );
    DatabaseTable table = MemoTable(
      id: maxId + 1,
      title: title,
      content: content,
      date: DateTime.now(),
    );
    final id = await _helper.insert(table);
    print('inserted memo_table id: $id');
    return id;
  }

  Future<void> updateScript(
      {@required int id, String title, String content}) async {
    DatabaseTable table = MemoTable(
      id: id,
      title: title,
      content: content,
      date: DateTime.now(),
    );
    await _helper.update(table);
  }

  Future<List<MemoTable>> getAllScript({trash = false, sort = false}) async {
    final res =
        await _helper.queryAll(trash ? TrashTable.name : MemoTable.name);
    List<MemoTable> tableList =
        res.map((row) => MemoTable.fromMap(row)).toList();
    if (sort) tableList.sort((a, b) => b.date.compareTo(a.date));
    return tableList;
  }

  Future<List<MemoTable>> searchScript({@required String keyword}) async {
    final res = await _helper.search(keyword);
    List<MemoTable> tableList = res.map((row) => MemoTable.fromMap(row)).toList();
    tableList.sort((a, b) => b.date.compareTo(a.date));
    return tableList;
  }

  Future<List<MemoTable>> getScriptByTagId({@required int tagId}) async {
    final res = await _helper.queryMemoByTagId(tagId);
    List<MemoTable> tableList =
        res.map((row) => MemoTable.fromMap(row)).toList();
    tableList.sort((a, b) => b.date.compareTo(a.date));
    return tableList;
  }

  Future<int> moveToTrash({@required int memoId}) async {
    await updateScript(id: memoId);
    final res = await _helper.queryById(MemoTable.name, memoId);
    DatabaseTable table = TrashTable.fromMap(res);
    final trashId = await _helper.insert(table);
    await _helper.delete(MemoTable.name, memoId);
    print('deleted memo_table id: $memoId');
    return trashId;
  }

  Future<int> restoreFromTrash({@required int trashId}) async {
    final res = await _helper.queryById(TrashTable.name, trashId);
    DatabaseTable table = MemoTable.fromMap(res);
    final memoId = await _helper.insert(table);
    await _helper.delete(TrashTable.name, trashId);
    print('restored memo_table id: $memoId');
    return memoId;
  }

  Future<void> clearTrash() async {
    final trashTable = await getAllScript(trash: true);
    trashTable.forEach((element) {
      _helper.delete(TagMemoTable.name, element.id, idName: "memo_id");
    });
    await _helper.deleteAll(TrashTable.name);
  }

  Future<void> deleteTrash({@required int trashId}) async {
    _helper.delete(TagMemoTable.name, trashId, idName: "memo_id");
    await _helper.delete(TrashTable.name, trashId);
  }
}
