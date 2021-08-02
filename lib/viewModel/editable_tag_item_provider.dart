import 'package:flutter/material.dart';

class EditableTagItemProvider with ChangeNotifier {
  List<String> _tagList = ['宮沢賢治', '練習用'];
  List<bool> _checkList;

  get checkList {
    if (_checkList == null) {
      _checkList = List.filled(_tagList.length, false);
    }
    return _checkList;
  }

  bool _isDeleteSelectionMode = false;

  get isDeleteSelectionMode => _isDeleteSelectionMode;

  set isDeleteSelectionMode(bool mode) {
    _isDeleteSelectionMode = mode;
    notifyListeners();
  }

  void toggleChecked(int index) {
    checkList[index] = !checkList[index];
    notifyListeners();
  }
}
