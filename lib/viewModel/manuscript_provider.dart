import 'package:flutter/material.dart';
import 'package:presc/view/utils/script_card.dart';

class ManuscriptProvider with ChangeNotifier {
  String currentTag = '';
  bool _isVisibleSearchbar = true;
  List<Widget> _itemList;
  final List<Widget> _defaultItemList = List.generate(
    4,
    (i) => Container(
      height: 280,
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: ScriptCard("$i"),
    ),
  );

  get isVisibleSearchbar => _isVisibleSearchbar;

  set isVisibleSearchbar(bool visible) {
    _isVisibleSearchbar = visible;
    notifyListeners();
  }

  get itemList => _itemList;

  set itemList(String key) {
    if (key == '') {
      _itemList = _defaultItemList;
    } else {
      _itemList = List.generate(
        1,
        (i) => Container(
          height: 280,
          margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: ScriptCard("$key$i"),
        ),
      );
    }
    currentTag = key;
    notifyListeners();
  }

  ManuscriptProvider() {
    _itemList = _defaultItemList;
  }
}
