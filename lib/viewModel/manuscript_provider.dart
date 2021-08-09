import 'dart:async';

import 'package:flutter/material.dart';
import 'package:presc/model/manuscript_manager.dart';
import 'package:presc/model/utils/database_table.dart';

class ManuscriptProvider with ChangeNotifier {
  final listKey = GlobalKey<AnimatedListState>();
  final _manager = ManuscriptManager();

  int currentScriptLength = 0;
  String currentTag = "";

  ManuscriptState _state = ManuscriptState.home;

  ManuscriptState get state => _state;

  ManuscriptProvider() {
    _loadScriptList();
  }

  List<MemoTable> _scriptTable;

  List<MemoTable> get scriptTable => _scriptTable;

  Future<void> _loadScriptList() async {
    _scriptTable = await _manager.getAllScript();
    final _listKeyMonitor = (Timer t) {
      if (listKey.currentState != null) {
        t.cancel();
        replaceState(ManuscriptState.home);
      }
    };
    Timer.periodic(Duration(milliseconds: 100), _listKeyMonitor);
    notifyListeners();
  }

  Future<void> replaceState(ManuscriptState state,
      {int tagId, String tagName = ""}) async {
    for (int i = 0; i < currentScriptLength; i++) removeScriptItem(0);
    switch (state) {
      case ManuscriptState.home:
        _scriptTable = await _manager.getAllScript();
        break;
      case ManuscriptState.tag:
        if (tagId == null) return;
        _scriptTable = await _manager.getScriptByTagId(tagId);
        break;
      case ManuscriptState.trash:
        _scriptTable = await _manager.getAllScript(trash: true);
        break;
    }
    for (int i = 0; i < _scriptTable.length; i++) insertScriptItem(0);

    _state = state;
    currentScriptLength = _scriptTable.length;
    currentTag = tagName;
    notifyListeners();
  }

  void removeScriptItem(int index) => listKey.currentState
      ?.removeItem(index, (context, animation) => Container());

  void insertScriptItem(int index) => listKey.currentState
      ?.insertItem(index, duration: Duration(milliseconds: 400));

  Future<void> saveScript({
    @required int id,
    String title,
    String content,
  }) async {
    await _manager.updateScript(id: id, title: title, content: content);
  }

  Future<int> moveToTrash(int id) async => await _manager.moveToTrash(id);

  Future<int> restoreFromTrash(int id) async =>
      await _manager.restoreFromTrash(id);

  Future<void> updateScriptTable() async {
    _scriptTable = await _manager.getAllScript(
      trash: state == ManuscriptState.trash,
    );
    currentScriptLength = _scriptTable.length;
  }

  Future<void> notifyBack(BuildContext context) async {
    Navigator.pop(context);
    await updateScriptTable();
    notifyListeners();
  }
}

enum ManuscriptState { home, tag, trash }
