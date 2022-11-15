import 'dart:async';

import 'package:flutter/material.dart';
import 'package:presc/model/manuscript_manager.dart';
import 'package:presc/model/utils/database_table.dart';

class ManuscriptProvider with ChangeNotifier {
  final _manager = ManuscriptManager();

  Current _current = Current();

  Current get current => _current;

  List<MemoTable>? _scriptTable;

  List<MemoTable> get scriptTable {
    if (_scriptTable == null) return [];
    return _scriptTable!;
  }

  ManuscriptProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future(() async {
        _manager.deleteTrashAutomatically();
        _scriptTable = await _manager.getAllScript();
        notifyListeners();
      });
    });
  }

  Future<void> replaceState(
    ManuscriptState state, {
    int? tagId,
    String tagName = "",
    String searchWord = "",
  }) async {
    _current = Current();
    switch (state) {
      case ManuscriptState.home:
        _scriptTable = await _manager.getAllScript();
        break;
      case ManuscriptState.tag:
        if (tagId == null) return;
        _scriptTable = await _manager.getScriptByTagId(tagId: tagId);
        _current.tagTable = TagTable(id: tagId, tagName: tagName);
        break;
      case ManuscriptState.trash:
        _scriptTable = await _manager.getAllScript(trash: true);
        break;
      case ManuscriptState.search:
        _scriptTable = searchWord.isNotEmpty
            ? await _manager.searchScript(keyword: searchWord)
            : [];
        _current.searchWord = searchWord;
        break;
    }
    _current.state = state;
    notifyListeners();
  }

  Future<int> addScript({
    required String title,
    required String content,
  }) async =>
      await _manager.addScript(title: title, content: content);

  Future<void> saveScript({
    required int id,
    String? title,
    String? content,
  }) async {
    await _manager.updateScript(id: id, title: title, content: content);
  }

  Future<int> moveToTrash({required int memoId}) async =>
      await _manager.moveToTrash(memoId: memoId);

  Future<int> restoreFromTrash({required int trashId}) async =>
      await _manager.restoreFromTrash(trashId: trashId);

  Future<void> updateScriptTable() async {
    replaceState(
      _current.state,
      tagId: _current.tagTable?.id,
      tagName: _current.tagTable?.tagName ?? "",
      searchWord: _current.searchWord,
    );
    notifyListeners();
  }

  Future<void> clearTrash() async => await _manager.clearTrash();

  Future<void> deleteTrash({required int trashId}) async =>
      await _manager.deleteTrash(trashId: trashId);

  Future<void> notifyBack(BuildContext context) async {
    Navigator.pop(context);
    await updateScriptTable();
  }
}

class Current {
  Current({this.tagTable, this.searchWord = ""});

  ManuscriptState state = ManuscriptState.home;
  TagTable? tagTable;
  String searchWord;
}

enum ManuscriptState { home, tag, trash, search }
