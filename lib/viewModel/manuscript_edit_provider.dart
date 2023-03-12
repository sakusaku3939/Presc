import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/undo_redo_history.dart';
import '../view/utils/trash_move_snackbar.dart';
import 'manuscript_provider.dart';

class ManuscriptEditProvider with ChangeNotifier {
  late ManuscriptProvider _script;
  late UndoRedoHistory _history;
  int _index = -1;

  int? _id;
  String? _title;
  String? _content;
  DateTime? _date;

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

  set content(String value) {
    _content = value;
    _history.add(value);
    _updateContent();
  }

  DateTime get date => _date ?? DateTime(0);

  void init(BuildContext context, int index) {
    _script = context.read<ManuscriptProvider>();

    final scriptTable = _script.scriptTable[index];
    _index = index;
    _id = scriptTable.id;
    _title = scriptTable.title ?? "";
    _content = scriptTable.content ?? "";
    _date = scriptTable.date;
    _history = UndoRedoHistory(_content);
  }

  Future<void> back(BuildContext context) async {
    _script = context.read<ManuscriptProvider>();
    await _script.notifyBack(context);
    if (_index != -1 && _title == "" && _content == "") {
      await Future.delayed(Duration(milliseconds: 300));
      TrashMoveSnackBar.deleteEmpty(
        context: context,
        provider: _script,
        index: _index,
      );
    }
    _history.clear();
  }

  bool get isEditable => _script.current.state != ManuscriptState.trash;

  bool get canUndo => _history.canUndo();

  void undo() {
    if (!_history.canUndo()) return;
    _history.undo();
    _content = _history.current ?? "";
    _updateContent();
  }

  bool get canRedo => _history.canRedo();

  void redo() {
    if (!_history.canRedo()) return;
    _history.redo();
    _content = _history.current;
    _updateContent();
  }

  Future<void> _updateContent() async {
    await _script.saveScript(id: id, content: _content);
    await _script.updateScriptTable();
    notifyListeners();
  }
}
