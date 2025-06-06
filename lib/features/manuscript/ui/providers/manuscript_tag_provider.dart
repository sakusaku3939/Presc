import 'package:flutter/material.dart';
import 'package:presc/features/tag/data/tag_repository.dart';
import 'package:presc/features/manuscript/data/models/database_table.dart';

class ManuscriptTagProvider with ChangeNotifier {
  final _tag = TagRepository();
  List<TagTable> _allTagTable = [];
  List<TagTable> _linkTagTable = [];
  List<TagTable> _unlinkTagTable = [];
  List<bool> _checkList = [];

  List<TagTable> get allTagTable => _allTagTable;

  List<TagTable> get linkTagTable => _linkTagTable;

  List<TagTable> get unlinkTagTable => _unlinkTagTable;

  List<bool> get checkList => _checkList;

  Future<void> loadTag({required int memoId}) async {
    final res = await Future.wait([
      _tag.getAll(),
      _tag.getLinkedTagById(memoId: memoId),
    ]);
    _allTagTable = res.first;
    _linkTagTable = res.last;

    final linkTagNameList = _linkTagTable.map((e) => e.tagName).toList();
    _unlinkTagTable = _allTagTable
        .where((e) => !linkTagNameList.contains(e.tagName))
        .toList();
    _checkList =
        _allTagTable.map((e) => linkTagNameList.contains(e.tagName)).toList();
    notifyListeners();
  }

  Future<void> changeChecked({
    required int memoId,
    required int tagId,
    required bool newValue,
  }) async {
    if (newValue) {
      await _tag.linkToMemo(memoId: memoId, tagId: tagId);
    } else {
      await _tag.unlinkMemo(memoId: memoId, tagId: tagId);
    }
    loadTag(memoId: memoId);
  }

  Future<void> addTag({required int memoId, String name = ""}) async {
    final id = await _tag.add(name: name);
    changeChecked(memoId: memoId, tagId: id, newValue: true);
    loadTag(memoId: memoId);
  }
}
