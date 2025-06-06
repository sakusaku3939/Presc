import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/undo_redo_history.dart';
import '../../../../view/utils/trash_move_manager.dart';
import 'manuscript_provider.dart';

class ManuscriptEditProvider with ChangeNotifier {
  late ManuscriptProvider _script;
  late UndoRedoHistory _history;

  int? _id;
  String? _title;
  String? _content;
  DateTime? _date;
  EditHistory? _currentHistory;

  int get id => _id ?? -1;

  String get title => _title ?? "";

  set title(String value) {
    _title = value;
    Future(() async {
      await _script.saveScript(id: id, title: value);
      await _script.updateScriptTable();
    });
  }

  String get content => _content ?? "";

  DateTime get date => _date ?? DateTime(0);

  EditHistory get currentHistory => _currentHistory ?? EditHistory("", 0);

  set currentHistory(EditHistory history) {
    _content = history.content;
    _history.add(history);
    _updateContent();
  }

  void init(BuildContext context, int index) {
    _script = context.read<ManuscriptProvider>();

    final scriptTable = _script.scriptTable[index];
    _id = scriptTable.id;
    _title = scriptTable.title ?? "";
    _content = scriptTable.content ?? "";
    _date = scriptTable.date;
    _history = UndoRedoHistory(EditHistory(content, 0));
  }

  Future<void> back(BuildContext context) async {
    _script = context.read<ManuscriptProvider>();
    _history.clear();
    Navigator.pop(context);
    if (_script.current.state != ManuscriptState.trash &&
        _title == "" &&
        _content == "") {
      await Future.delayed(Duration(milliseconds: 300));
      TrashMoveManager.deleteEmpty(context: context, id: id);
    }
  }

  bool get isEditable => _script.current.state != ManuscriptState.trash;

  bool get canUndo => _history.canUndo();

  void undo() {
    if (!_history.canUndo()) return;
    _history.undo();
    _currentHistory = _history.current;
    if (_currentHistory != null) {
      _content = _currentHistory!.content;
    }
    _updateContent();
  }

  bool get canRedo => _history.canRedo();

  void redo() {
    if (!_history.canRedo()) return;
    _history.redo();
    _currentHistory = _history.current;
    if (_currentHistory != null) {
      _content = _currentHistory!.content;
    }
    _updateContent();
  }

  Future<void> moveToTrash(BuildContext context) async {
    Navigator.pop(context);
    await Future.delayed(Duration(milliseconds: 300));
    TrashMoveManager.moveToTrash(context: context, id: id);
  }

  Future<void> restore(BuildContext context) async {
    Navigator.pop(context);
    await Future.delayed(Duration(milliseconds: 300));
    TrashMoveManager.restore(context: context, id: id);
  }

  Future<void> delete(BuildContext context) async {
    Navigator.pop(context);
    await Future.delayed(Duration(milliseconds: 300));
    TrashMoveManager.delete(context: context, id: id, title: title);
  }

  Future<void> _updateContent() async {
    await _script.saveScript(id: id, content: _content);
    await _script.updateScriptTable();
    notifyListeners();
  }
}

class EditHistory {
  EditHistory(this.content, this.offset);

  final String content;
  final int offset;
}
