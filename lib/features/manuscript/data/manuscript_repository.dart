import 'package:presc/features/manuscript/data/manuscript_datasource.dart';
import 'package:presc/features/manuscript/data/models/database_table.dart';

class ManuscriptRepository {
  final _manuscript = ManuscriptDatasource();

  Future<int> addScript({
    String title = "",
    String content = "",
    DateTime? date,
  }) async {
    final maxId = await _manuscript.queryMaxId(
      MemoTable.name,
      compareTableName: TrashTable.name,
    );
    DatabaseTable table = MemoTable(
      id: maxId + 1,
      title: title,
      content: content,
      date: date ?? DateTime.now(),
    );
    final id = await _manuscript.insert(table);
    print('inserted memo_table id: $id');
    return id;
  }

  Future<void> updateScript(
      {required int id, String? title, String? content}) async {
    DatabaseTable table = MemoTable(
      id: id,
      title: title,
      content: content,
      date: DateTime.now(),
    );
    await _manuscript.update(table);
  }

  Future<List<MemoTable>> getAllScript({trash = false}) async {
    final res =
        await _manuscript.queryAll(trash ? TrashTable.name : MemoTable.name);
    List<MemoTable> tableList =
        res.map((row) => MemoTable.fromMap(row)).toList();
    tableList.sort((a, b) => b.date.compareTo(a.date));
    return tableList;
  }

  Future<List<MemoTable>> searchScript({required String keyword}) async {
    final res = await _manuscript.search(keyword);
    List<MemoTable> tableList =
        res.map((row) => MemoTable.fromMap(row)).toList();
    tableList.sort((a, b) => b.date.compareTo(a.date));
    return tableList;
  }

  Future<List<MemoTable>> getScriptByTagId({required int tagId}) async {
    final res = await _manuscript.queryMemoByTagId(tagId);
    List<MemoTable> tableList =
        res.map((row) => MemoTable.fromMap(row)).toList();
    tableList.sort((a, b) => b.date.compareTo(a.date));
    return tableList;
  }

  Future<int> moveToTrash({required int memoId}) async {
    await updateScript(id: memoId);
    final res = await _manuscript.queryById(MemoTable.name, memoId);
    DatabaseTable table = TrashTable.fromMap(res);
    final trashId = await _manuscript.insert(table);
    await _manuscript.delete(MemoTable.name, memoId);
    print('deleted memo_table id: $memoId');
    return trashId;
  }

  Future<int> restoreFromTrash({required int trashId}) async {
    final res = await _manuscript.queryById(TrashTable.name, trashId);
    DatabaseTable table = MemoTable.fromMap(res);
    final memoId = await _manuscript.insert(table);
    await _manuscript.delete(TrashTable.name, trashId);
    print('restored memo_table id: $memoId');
    return memoId;
  }

  Future<void> clearTrash() async {
    final trashTable = await getAllScript(trash: true);
    trashTable.forEach((element) {
      _manuscript.delete(TagMemoTable.name, element.id, idName: "memo_id");
    });
    await _manuscript.deleteAll(TrashTable.name);
  }

  Future<void> deleteTrash({required int trashId}) async {
    _manuscript.delete(TagMemoTable.name, trashId, idName: "memo_id");
    await _manuscript.delete(TrashTable.name, trashId);
  }

  Future<void> deleteTrashAutomatically() async {
    final trashTable = await getAllScript(trash: true);
    trashTable.forEach((element) {
      final difference = DateTime.now().difference(element.date);
      if (difference.inDays >= 7) {
        deleteTrash(trashId: element.id);
      }
    });
  }
}
