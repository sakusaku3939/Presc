import 'package:flutter/material.dart';
import 'package:presc/model/TagManager.dart';
import 'package:presc/model/utils/database_table.dart';

class ManuscriptTagProvider with ChangeNotifier {
  final _manager = TagManager();
  List<TagTable> _allTagTable = [];
  List<TagTable> _linkTagTable = [];
  List<TagTable> _unlinkTagTable = [];
  List<bool> _checkList = [];

  List<TagTable> get allTagTable => _allTagTable;

  List<TagTable> get linkTagTable => _linkTagTable;

  List<TagTable> get unlinkTagTable => _unlinkTagTable;

  List<bool> get checkList => _checkList;

  Future<void> loadTag(int memoId) async {
    final res = await Future.wait([
      _manager.getAllTag(),
      _manager.getLinkTagById(memoId),
    ]);
    _allTagTable = res.first;
    _linkTagTable = res.last;

    final linkTagNameList = _linkTagTable.map((e) => e.tagName).toList();
    _unlinkTagTable = _allTagTable
        .where((e) => !linkTagNameList.contains(e.tagName))
        .toList();
    _checkList =
        _allTagTable.map((e) => linkTagNameList.contains(e.tagName)).toList();
    notifyListeners();
  }

  Future<void> changeChecked({
    @required int memoId,
    @required int tagId,
    @required bool newValue,
  }) async {
    if (newValue) {
      await _manager.linkTag(memoId, tagId);
    } else {
      await _manager.unlinkTag(memoId, tagId);
    }
    loadTag(memoId);
  }

  Future<void> addTag(int memoId, String name) async {
    final id = await _manager.addTag(name: name);
    changeChecked(memoId: memoId, tagId: id, newValue: true);
    loadTag(memoId);
  }

  Future<void> addTagTest(int memoId) async {
    int id1 = await _manager.addTag(name: "夏目漱石");
    int id2 = await _manager.addTag(name: "練習用");
    _manager.addTag(name: "テスト");
    _manager.linkTag(memoId, id1);
    _manager.linkTag(memoId, id2);
  }
}
