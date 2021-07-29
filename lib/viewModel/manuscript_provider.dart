import 'dart:async';

import 'package:flutter/material.dart';
import 'package:presc/model/manuscript_manager.dart';
import 'package:presc/model/utils/database_table.dart';
import 'package:presc/view/utils/script_card.dart';

class ManuscriptProvider with ChangeNotifier {
  final _listKey = GlobalKey<AnimatedListState>();
  final _manager = ManuscriptManager();

  int currentScriptLength = 0;
  String currentTag = '';

  int _state = ManuscriptState.home;

  get state => _state;

  AnimatedList _scriptList;

  get scriptList => _scriptList;

  ManuscriptProvider() {
    _loadScriptList();
  }

  List<MemoTable> _scriptTable;

  get scriptTable => _scriptTable;

  Future<void> _loadScriptList() async {
    _scriptTable = await _manager.queryAll();
    _scriptList = AnimatedList(
      key: _listKey,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      initialItemCount: 0,
      itemBuilder: (BuildContext context, int index, Animation animation) {
        return FadeTransition(
          opacity: animation,
          child: Container(
            height: 280,
            margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: ScriptCard("$_state$index", index),
          ),
        );
      },
    );
    currentScriptLength = scriptTable.length;
    final _listKeyMonitor = (Timer t) {
      if (_listKey.currentState != null) {
        t.cancel();
        for (int i = 0; i < currentScriptLength; i++)
          _listKey.currentState
              .insertItem(0, duration: Duration(milliseconds: 200));
      }
    };
    Timer.periodic(Duration(milliseconds: 100), _listKeyMonitor);
  }

  Future<void> replaceState(int state, int length, {String key = ""}) async {
    for (int i = 0; i < currentScriptLength; i++) {
      _listKey.currentState.removeItem(0, (context, animation) => Container());
    }
    for (int i = 0; i < length; i++) {
      _listKey.currentState
          .insertItem(0, duration: Duration(milliseconds: 400));
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
