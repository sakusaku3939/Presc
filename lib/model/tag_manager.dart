import 'package:flutter/material.dart';
import 'package:presc/model/utils/database_helper.dart';
import 'package:presc/model/utils/database_table.dart';

class TagManager {
  final _helper = DatabaseHelper();

  Future<int> addTag({String name = ""}) async {
    DatabaseTable table = TagTable(
      id: await _helper.queryMaxId(TagTable.name) + 1,
      tagName: name,
    );
    final id = await _helper.insert(table);
    print('inserted tag_table id: $id');
    return id;
  }

  Future<void> updateTag({required int id, required String name}) async {
    DatabaseTable table = TagTable(
      id: id,
      tagName: name,
    );
    await _helper.update(table);
  }

  Future<void> deleteTag({required int id}) async {
    await _helper.delete(TagMemoTable.name, id, idName: "tag_id");
    await _helper.delete(TagTable.name, id);
    print('deleted tag_table id: $id');
  }

  Future<void> linkTag({required int memoId, required int tagId}) async {
    DatabaseTable table = TagMemoTable(
      memoId: memoId,
      tagId: tagId,
    );
    await _helper.insert(table);
  }

  Future<void> unlinkTag({required int memoId, required int tagId}) async {
    await _helper.execute(
      'DELETE FROM ${TagMemoTable.name} WHERE memo_id = ? AND tag_id = ?',
      [memoId, tagId],
    );
  }

  Future<List<TagTable>> getAllTag() async {
    final res = await _helper.queryAll(TagTable.name);
    List<TagTable> tableList = res.map((row) => TagTable.fromMap(row)).toList();
    return tableList;
  }

  Future<List<TagTable>> getLinkTagById({required int memoId}) async {
    final res = await _helper.queryTagByMemoId(memoId);
    List<TagTable> tableList = res.map((row) => TagTable.fromMap(row)).toList();
    return tableList;
  }
}
