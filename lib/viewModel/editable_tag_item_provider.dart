import 'package:flutter/material.dart';

class EditableTagItemProvider with ChangeNotifier {
  List<String> _tagList = ['宮沢賢治', '練習用'];
  List<bool> _checkedList;

  get checkedList {
    if (_checkedList == null) {
      _checkedList = List.filled(_tagList.length, false);
    }
    return _checkedList;
  }

  bool _isDeleteSelectionMode = false;

  get isDeleteSelectionMode => _isDeleteSelectionMode;

  set isDeleteSelectionMode(bool mode) {
    _isDeleteSelectionMode = mode;
    notifyListeners();
  }

  void toggleChecked(int index) {
    checkedList[index] = !checkedList[index];
    notifyListeners();
  }
}
