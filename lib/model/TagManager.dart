import 'package:flutter/material.dart';
import 'package:presc/model/utils/database_helper.dart';
import 'package:presc/model/utils/database_table.dart';

class TagManager {
  final _dbHelper = DatabaseHelper.instance;

  Future<int> addTag({String name = ""}) async {
    DatabaseTable table = TagTable(
      id: await _dbHelper.queryMaxId(TagTable.name) + 1,
      tagName: name,
    );
    final id = await _dbHelper.insert(table);
    print('inserted tag_table id: $id');
    return id;
  }

  Future<void> updateTag({@required int id, @required String name}) async {
    DatabaseTable table = TagTable(
      id: id,
      tagName: name,
    );
    await _dbHelper.update(table);
    print('update id: $id');
  }

  Future<void> linkTag(int memoId, int tagId) async {
    DatabaseTable table = TagMemoTable(
      memoId: memoId,
      tagId: tagId,
    );
    await _dbHelper.insert(table);
    print('link tag_id: $tagId');
  }

  Future<void> unlinkTag(int memoId, int tagId) async {
    await _dbHelper.execute(
      'DELETE FROM ${TagMemoTable.name} WHERE memo_id = ? AND tag_id = ?',
      [memoId, tagId],
    );
    print('unlink tag_id: $tagId');
  }

  Future<List<TagTable>> getAllTag() async {
    final res = await _dbHelper.queryAll(TagTable.name);
    List<TagTable> tableList = res.map((row) => TagTable.fromMap(row)).toList();
    return tableList;
  }

  Future<List<TagTable>> getLinkTagById(int memoId) async {
    final res = await _dbHelper.queryTagById(memoId);
    List<TagTable> tableList = res.map((row) => TagTable.fromMap(row)).toList();
    return tableList;
  }
}
