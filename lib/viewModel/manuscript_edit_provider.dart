import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view/utils/trash_move_snackbar.dart';
import 'manuscript_provider.dart';

class ManuscriptEditProvider with ChangeNotifier {
  late ManuscriptProvider _script;
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
    Future(() async {
      await _script.saveScript(id: id, content: value);
      await _script.updateScriptTable();
    });
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
  }

  bool get isEditable => _script.current.state != ManuscriptState.trash;
}
