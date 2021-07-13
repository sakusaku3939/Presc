import 'package:flutter/material.dart';

class EditableTagItemProvider with ChangeNotifier {
  List<bool> checkedList = List.filled(['宮沢賢治', '練習用'].length, false);

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
