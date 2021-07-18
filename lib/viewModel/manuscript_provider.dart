import 'package:flutter/material.dart';
import 'package:presc/view/utils/script_card.dart';

class ManuscriptProvider with ChangeNotifier {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List _itemList = List.generate(4, (index) => index);
  String currentTag = '';

  int _state = ManuscriptState.home;

  get state => _state;

  set state(int state) {
    _state = state;
    notifyListeners();
  }

  AnimatedList _scriptList;

  get scriptList {
    _scriptList = _scriptList ??
        AnimatedList(
          key: _listKey,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          initialItemCount: _itemList.length,
          itemBuilder: (BuildContext context, int index, Animation animation) {
            return FadeTransition(
              opacity: animation,
              child: Container(
                height: 280,
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: ScriptCard("$_state$index"),
              ),
            );
          },
        );
    return _scriptList;
  }

  void replace(String key, int length) {
    for (int i = 0; i < _itemList.length; i++) {
      _listKey.currentState.removeItem(0, (context, animation) => Container());
    }
    _itemList = List.generate(length, (index) => index);
    for (int i = 0; i < length; i++) {
      _listKey.currentState
          .insertItem(0, duration: Duration(milliseconds: 300));
    }
    currentTag = key;
    notifyListeners();
  }
}

class ManuscriptState {
  static const int home = 0;
  static const int tag = 1;
  static const int trash = 2;
}
