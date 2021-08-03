import 'package:flutter/material.dart';
import 'package:presc/model/TagManager.dart';
import 'package:presc/model/utils/database_table.dart';

class EditableTagItemProvider with ChangeNotifier {
  final _manager = TagManager();
  List<String> _tagList = ['宮沢賢治', '練習用'];
  List<TagTable> _allTagTable = [];

  List<TagTable> get allTagTable => _allTagTable;

  List<bool> _checkList;

  List<bool> get checkList {
    if (_checkList == null) _initializeCheckList();
    return _checkList;
  }

  bool _isDeleteSelectionMode = false;

  get isDeleteSelectionMode => _isDeleteSelectionMode;

  set isDeleteSelectionMode(bool mode) {
    _initializeCheckList();
    _isDeleteSelectionMode = mode;
    notifyListeners();
  }

  Future<void> loadTag() async {
    _allTagTable = await _manager.getAllTag();
    notifyListeners();
  }

  Future<void> addTag(String name) async {
    await _manager.addTag(name: name);
    loadTag();
  }

  Future<void> updateTag(int id, String name) async {
    await _manager.updateTag(id: id, name: name);
  }

  Future<void> deleteTag(int id) async {
    await _manager.deleteTag(id: id);
    loadTag();
  }

  void _initializeCheckList() =>
      _checkList = List.filled(_allTagTable.length, false);

  void toggleChecked(int index) {
    checkList[index] = !checkList[index];
    notifyListeners();
  }
}
