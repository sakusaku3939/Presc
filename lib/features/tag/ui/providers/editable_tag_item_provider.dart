import 'package:flutter/material.dart';
import 'package:presc/features/tag/data/tag_repository.dart';
import 'package:presc/features/manuscript/data/models/database_table.dart';

class EditableTagItemProvider with ChangeNotifier {
  final _tag = TagRepository();
  List<TagTable> _allTagTable = [];

  List<TagTable> get allTagTable => _allTagTable;

  List<bool>? _checkList;

  List<bool> get checkList {
    if (_checkList == null) _initializeCheckList();
    return _checkList!;
  }

  bool _isDeleteSelectionMode = false;

  bool get isDeleteSelectionMode => _isDeleteSelectionMode;

  set isDeleteSelectionMode(bool mode) {
    _initializeCheckList();
    _isDeleteSelectionMode = mode;
    notifyListeners();
  }

  TagTable? getTag(int id) {
    return _allTagTable.firstWhere((e) => e.id == id, orElse: null);
  }

  Future<void> loadTag() async {
    _allTagTable = await _tag.getAll();
    notifyListeners();
  }

  Future<void> addTag(String name) async {
    await _tag.add(name: name);
    loadTag();
  }

  Future<void> updateTag(int id, String name) async {
    await _tag.update(id: id, name: name);
    loadTag();
  }

  Future<void> deleteTag(int id) async {
    await _tag.delete(id: id);
    loadTag();
  }

  void _initializeCheckList() =>
      _checkList = List.filled(_allTagTable.length, false);

  void toggleChecked(int index) {
    checkList[index] = !checkList[index];
    notifyListeners();
  }
}
