import 'package:flutter/material.dart';
import 'package:presc/view/utils/script_card.dart';

class ManuscriptProvider with ChangeNotifier {
  String currentTag = '';

  int _state = ManuscriptState.home;

  get state => _state;

  set state(int state) {
    _state = state;
    notifyListeners();
  }

  List<Widget> _itemList;
  final List<Widget> _defaultItemList = List.generate(
    4,
    (i) => Container(
      height: 280,
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: ScriptCard("$i"),
    ),
  );

  get itemList => _itemList;

  set itemList(String key) {
    final match = RegExp(r"([a-z]+)=([^&]+)").allMatches(key);
    final keyType = match.isNotEmpty ? match.first.group(1) : "";
    final keyName = match.isNotEmpty ? match.first.group(2) : "";

    switch (keyType) {
      case "tag":
        _itemList = _generateScriptCard(key, 1);
        break;
      case "trash":
        _itemList = _generateScriptCard(key, 2);
        break;
      default:
        _itemList = _defaultItemList;
        break;
    }
    currentTag = keyName;
    notifyListeners();
  }

  ManuscriptProvider() {
    _itemList = _defaultItemList;
  }

  List<Widget> _generateScriptCard(String key, int length) {
    return List.generate(
      length,
      (i) => Container(
        height: 280,
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: ScriptCard("$key$i"),
      ),
    );
  }
}

class ManuscriptState {
  static const int home = 0;
  static const int tag = 1;
  static const int trash = 2;
}
