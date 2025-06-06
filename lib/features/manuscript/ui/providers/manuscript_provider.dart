import 'dart:async';

import 'package:flutter/material.dart';
import 'package:presc/features/manuscript/data/manuscript_repository.dart';
import 'package:presc/model/utils/database_table.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/tag_manager.dart';

class ManuscriptProvider with ChangeNotifier {
  final _manager = ManuscriptRepository();

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

        final prefs = await SharedPreferences.getInstance();
        final tagId = prefs.getInt("currentTagId") ?? -1;
        if (tagId != -1) {
          final _tagManager = TagManager();
          _current.state = ManuscriptState.tag;
          _current.tagTable = await _tagManager.getTagById(tagId);
        }

        await updateScriptTable();
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
    _saveCurrentState(-1);

    switch (state) {
      case ManuscriptState.home:
        _scriptTable = await _manager.getAllScript();
        break;
      case ManuscriptState.tag:
        if (tagId == null) return;
        _scriptTable = await _manager.getScriptByTagId(tagId: tagId);
        _current.tagTable = TagTable(id: tagId, tagName: tagName);
        _saveCurrentState(tagId);
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
  }

  Future<void> clearTrash() async => await _manager.clearTrash();

  Future<void> deleteTrash({required int trashId}) async =>
      await _manager.deleteTrash(trashId: trashId);

  Future<void> _saveCurrentState(int tagId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("currentTagId", tagId);
  }
}

class Current {
  Current({this.tagTable, this.searchWord = ""});

  ManuscriptState state = ManuscriptState.home;
  TagTable? tagTable;
  String searchWord;
}

enum ManuscriptState { home, tag, trash, search }
