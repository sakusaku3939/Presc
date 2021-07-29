import 'dart:async';

import 'package:flutter/material.dart';
import 'package:presc/model/manuscript_manager.dart';
import 'package:presc/model/utils/database_table.dart';

class ManuscriptProvider with ChangeNotifier {
  final listKey = GlobalKey<AnimatedListState>();
  final _manager = ManuscriptManager();

  int currentScriptLength = 0;
  String currentTag = '';

  int _state = ManuscriptState.home;

  get state => _state;

  ManuscriptProvider() {
    _loadScriptList();
  }

  List<MemoTable> _scriptTable;

  get scriptTable => _scriptTable;

  Future<void> _loadScriptList() async {
    _scriptTable = await _manager.queryAll();
    final _listKeyMonitor = (Timer t) {
      if (listKey.currentState != null) {
        t.cancel();
        replaceState(ManuscriptState.home, scriptTable.length);
      }
    };
    Timer.periodic(Duration(milliseconds: 100), _listKeyMonitor);
    notifyListeners();
  }

  Future<void> replaceState(int state, int length, {String key = ""}) async {
    for (int i = 0; i < currentScriptLength; i++) {
      listKey.currentState?.removeItem(0, (context, animation) => Container());
    }
    for (int i = 0; i < length; i++) {
      listKey.currentState
          ?.insertItem(0, duration: Duration(milliseconds: 400));
    }
    _state = state;
    currentScriptLength = length;
    currentTag = key;
    notifyListeners();
  }

  Future<void> saveScript({
    @required int id,
    String title,
    String content,
  }) async {
    await _manager.update(id: id, title: title, content: content);
  }

  Future<void> notifyBack(BuildContext context) async {
    Navigator.pop(context);
    _scriptTable = await _manager.queryAll();
    notifyListeners();
  }
}

class ManuscriptState {
  static const int home = 0;
  static const int tag = 1;
  static const int trash = 2;
}
