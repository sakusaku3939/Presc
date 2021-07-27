import 'package:flutter/material.dart';
import 'package:presc/model/manuscript_manager.dart';
import 'package:presc/view/utils/script_card.dart';

class ManuscriptProvider with ChangeNotifier {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final manager = ManuscriptManager();

  int currentScriptLength = 0;
  String currentTag = '';

  int _state = ManuscriptState.home;

  get state => _state;

  AnimatedList _scriptList;

  get scriptList => _scriptList;

  ManuscriptProvider() {
    _loadScriptList();
  }

  Future<void> _loadScriptList() async {
    final tableList = await manager.queryAll();
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
            child: ScriptCard(
              "$_state$index",
              title: tableList[index].title,
              content: tableList[index].content,
              date: tableList[index].date,
            ),
          ),
        );
      },
    );
    currentScriptLength = tableList.length;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => {
        for (int i = 0; i < currentScriptLength; i++)
          _listKey.currentState
              .insertItem(0, duration: Duration(milliseconds: 400))
      },
    );
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
}

class ManuscriptState {
  static const int home = 0;
  static const int tag = 1;
  static const int trash = 2;
}
