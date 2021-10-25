import 'dart:async';

import 'package:flutter/material.dart';
import 'package:presc/model/manuscript_manager.dart';
import 'package:presc/model/utils/database_table.dart';

class ManuscriptProvider with ChangeNotifier {
  final _manager = ManuscriptManager();

  ManuscriptState _state = ManuscriptState.home;

  ManuscriptState get state => _state;

  List<MemoTable> _scriptTable;

  List<MemoTable> get scriptTable => _scriptTable;

  TagTable _currentTagTable;

  TagTable get currentTagTable => _currentTagTable;

  set currentTagTable(TagTable tagTable) {
    _currentTagTable = tagTable;
    notifyListeners();
  }

  ManuscriptProvider() {
    Future(() async {
      _manager.deleteTrashAutomatically();
      _scriptTable = await _manager.getAllScript();
      notifyListeners();
    });
  }

  Future<void> replaceState(ManuscriptState state,
      {int tagId, String tagName = "", String searchWord = ""}) async {
    switch (state) {
      case ManuscriptState.home:
        _scriptTable = await _manager.getAllScript();
        break;
      case ManuscriptState.tag:
        if (tagId == null) return;
        _scriptTable = await _manager.getScriptByTagId(tagId: tagId);
        break;
      case ManuscriptState.trash:
        _scriptTable = await _manager.getAllScript(trash: true);
        break;
      case ManuscriptState.search:
        _scriptTable = searchWord.isNotEmpty
            ? await _manager.searchScript(keyword: searchWord)
            : [];
        break;
    }
    _state = state;
    _currentTagTable = TagTable(id: tagId, tagName: tagName);
    notifyListeners();
  }

  Future<int> addScript({
    String title,
    String content,
  }) async =>
      await _manager.addScript(title: title, content: content);

  Future<void> saveScript({
    @required int id,
    String title,
    String content,
  }) async {
    await _manager.updateScript(id: id, title: title, content: content);
  }

  Future<int> moveToTrash({@required int memoId}) async =>
      await _manager.moveToTrash(memoId: memoId);

  Future<int> restoreFromTrash({@required int trashId}) async =>
      await _manager.restoreFromTrash(trashId: trashId);

  Future<void> updateScriptTable() async {
    _scriptTable = await _manager.getAllScript(
      trash: state == ManuscriptState.trash,
    );
    notifyListeners();
  }

  Future<void> clearTrash() async => await _manager.clearTrash();

  Future<void> deleteTrash({@required int trashId}) async =>
      await _manager.deleteTrash(trashId: trashId);

  Future<void> notifyBack(BuildContext context) async {
    Navigator.pop(context);
    await updateScriptTable();
  }
}

enum ManuscriptState { home, tag, trash, search }
