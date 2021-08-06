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

  get state => _state;

  ManuscriptProvider() {
    _loadScriptList();
  }

  List<MemoTable> _scriptTable;

  get scriptTable => _scriptTable;

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

  Future<void> replaceState(ManuscriptState state, {int tagId, String tagName = ""}) async {
    for (int i = 0; i < currentScriptLength; i++) {
      listKey.currentState?.removeItem(0, (context, animation) => Container());
    }
    switch (state) {
      case ManuscriptState.home:
        _scriptTable = await _manager.getAllScript();
        break;
      case ManuscriptState.tag:
        if (tagId == null) return;
        _scriptTable = await _manager.getScriptByTagId(tagId);
        break;
      case ManuscriptState.trash:
        // @TODO ごみ箱の実装
        break;
    }
    for (int i = 0; i < _scriptTable.length; i++) {
      listKey.currentState
          ?.insertItem(0, duration: Duration(milliseconds: 400));
    }
    _state = state;
    currentScriptLength = _scriptTable.length;
    currentTag = tagName;
    notifyListeners();
  }

  Future<void> saveScript({
    @required int id,
    String title,
    String content,
  }) async {
    await _manager.updateScript(id: id, title: title, content: content);
  }

  Future<void> notifyBack(BuildContext context) async {
    Navigator.pop(context);
    _scriptTable = await _manager.getAllScript();
    notifyListeners();
  }
}

enum ManuscriptState {
  home,
  tag,
  trash,
}
