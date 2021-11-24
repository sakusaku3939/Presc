import 'package:flutter/material.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/viewModel/manuscript_provider.dart';

import 'dialog/dialog_manager.dart';

class TrashMoveManager {
  static Future<void> move({
    @required BuildContext context,
    @required ManuscriptProvider provider,
    @required int index,
  }) async {
    final newId = await provider.moveToTrash(
      memoId: provider.scriptTable[index].id,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.current.trashMoved),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: S.current.undo,
          onPressed: () async {
            await provider.restoreFromTrash(trashId: newId);
            await provider.updateScriptTable();
          },
        ),
      ),
    );
    await provider.updateScriptTable();
  }

  static Future<void> deleteEmpty({
    @required BuildContext context,
    @required ManuscriptProvider provider,
    @required int index,
  }) async {
    final newId = await provider.moveToTrash(
      memoId: provider.scriptTable[index].id,
    );
    await provider.deleteTrash(trashId: newId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.current.emptyScriptDeleted),
        duration: const Duration(seconds: 3),
      ),
    );
    await provider.updateScriptTable();
  }

  static Future<void> restore({
    @required BuildContext context,
    @required ManuscriptProvider provider,
    @required int index,
  }) async {
    final newId = await provider.restoreFromTrash(
      trashId: provider.scriptTable[index].id,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.current.trashRestored),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: S.current.undo,
          onPressed: () async {
            await provider.moveToTrash(memoId: newId);
            await provider.updateScriptTable();
          },
        ),
      ),
    );
    await provider.updateScriptTable();
  }

  static Future<void> delete({
    @required BuildContext context,
    @required ManuscriptProvider provider,
    @required int index,
  }) async {
    final title = provider.scriptTable[index].title;
    DialogManager.show(
      context,
      content: Text(S.current.doDeletePermanently(
          title.isNotEmpty ? title : "(${S.current.noTitle})")),
      actions: [
        DialogTextButton(
          S.current.cancel,
          onPressed: () => Navigator.pop(context),
        ),
        DialogTextButton(
          S.current.delete,
          onPressed: () async {
            await provider.deleteTrash(trashId: provider.scriptTable[index].id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.current.permanentlyDeleted),
                duration: const Duration(seconds: 2),
              ),
            );
            await provider.updateScriptTable();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
