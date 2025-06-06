import 'package:presc/features/manuscript/data/manuscript_datasource.dart';
import 'package:presc/features/manuscript/data/models/database_table.dart';

class TagRepository {
  final _manuscript = ManuscriptDatasource();

  Future<int> add({String name = ""}) async {
    DatabaseTable table = TagTable(
      id: await _manuscript.queryMaxId(TagTable.name) + 1,
      tagName: name,
    );
    final id = await _manuscript.insert(table);
    print('inserted tag_table id: $id');
    return id;
  }

  Future<void> update({required int id, required String name}) async {
    DatabaseTable table = TagTable(
      id: id,
      tagName: name,
    );
    await _manuscript.update(table);
  }

  Future<void> delete({required int id}) async {
    await _manuscript.delete(TagMemoTable.name, id, idName: "tag_id");
    await _manuscript.delete(TagTable.name, id);
    print('deleted tag_table id: $id');
  }

  Future<void> linkToMemo({required int memoId, required int tagId}) async {
    DatabaseTable table = TagMemoTable(
      memoId: memoId,
      tagId: tagId,
    );
    await _manuscript.insert(table);
  }

  Future<void> unlinkMemo({required int memoId, required int tagId}) async {
    await _manuscript.execute(
      'DELETE FROM ${TagMemoTable.name} WHERE memo_id = ? AND tag_id = ?',
      [memoId, tagId],
    );
  }

  Future<List<TagTable>> getAll() async {
    final res = await _manuscript.queryAll(TagTable.name);
    List<TagTable> tableList = res.map((row) => TagTable.fromMap(row)).toList();
    return tableList;
  }

  Future<TagTable> getTagById(int id) async {
    final res = await _manuscript.queryById(TagTable.name, id);
    TagTable table = TagTable.fromMap(res);
    return table;
  }

  Future<List<TagTable>> getLinkedTagById({required int memoId}) async {
    final res = await _manuscript.queryTagByMemoId(memoId);
    List<TagTable> tableList = res.map((row) => TagTable.fromMap(row)).toList();
    return tableList;
  }
}
