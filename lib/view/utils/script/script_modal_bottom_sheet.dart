import 'package:flutter/material.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/model/utils/database_table.dart';
import 'package:presc/view/screens/playback.dart';
import 'package:presc/view/utils/trash_move_manager.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:provider/provider.dart';

class ScriptModalBottomSheet {
  static void show(BuildContext context, MemoTable scriptTable) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) {
        return _sheet(context, scriptTable);
      },
    );
  }

  static Widget _sheet(BuildContext context, MemoTable scriptTable) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 30,
            height: 4,
            margin: const EdgeInsets.only(top: 6, bottom: 4),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Consumer<ManuscriptProvider>(
            builder: (_, model, child) {
              return model.current.state != ManuscriptState.trash
                  ? _defaultSheet(context, model, scriptTable)
                  : _trashSheet(context, model, scriptTable);
            },
          ),
        ],
      ),
    );
  }

  static Widget _defaultSheet(
    BuildContext context,
    ManuscriptProvider model,
    MemoTable scriptTable,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Transform.translate(
            offset: Offset(8, 0),
            child: Icon(Icons.play_arrow_outlined),
          ),
          title: Text(S.current.onboardingPlayScript),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaybackScreen(
                  title: scriptTable.title ?? "",
                  content: scriptTable.content ?? "",
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: Transform.translate(
            offset: Offset(8, 0),
            child: Icon(Icons.delete_outline),
          ),
          title: Text(S.current.moveTrash),
          onTap: () {
            TrashMoveManager.moveToTrash(context: context, id: scriptTable.id);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  static Widget _trashSheet(
    BuildContext context,
    ManuscriptProvider model,
    MemoTable scriptTable,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Transform.translate(
            offset: Offset(8, 0),
            child: Icon(Icons.restore_outlined),
          ),
          title: Text(S.current.restore),
          onTap: () {
            TrashMoveManager.restore(context: context, id: scriptTable.id);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Transform.translate(
            offset: Offset(8, 0),
            child: Icon(Icons.delete_outlined),
          ),
          title: Text(S.current.deletePermanently),
          onTap: () {
            Navigator.pop(context);
            TrashMoveManager.delete(
              context: context,
              id: scriptTable.id,
              title: scriptTable.title ?? "",
            );
          },
        ),
      ],
    );
  }
}
