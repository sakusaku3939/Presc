import 'package:flutter/material.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/view/utils/dialog/platform_dialog_manager.dart';
import 'package:presc/viewModel/manuscript_provider.dart';

class TrashMoveSnackBar {
  static Future<void> move({
    required BuildContext context,
    required ManuscriptProvider provider,
    required int index,
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
    required BuildContext context,
    required ManuscriptProvider provider,
    required int index,
  }) async {
    await provider.moveToTrash(
      memoId: provider.scriptTable[index].id,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.current.emptyScriptDeleted),
        duration: const Duration(seconds: 3),
      ),
    );
    await provider.updateScriptTable();
  }

  static Future<void> restore({
    required BuildContext context,
    required ManuscriptProvider provider,
    required int index,
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
    required BuildContext context,
    required ManuscriptProvider provider,
    required int index,
  }) async {
    final title = provider.scriptTable[index].title;
    await PlatformDialogManager.showDeleteAlert(
      context,
      message: S.current.doDeletePermanently(
        (title != null && title.isNotEmpty) ? title : "(${S.current.noTitle})",
      ),
      deleteLabel: S.current.delete,
      cancelLabel: S.current.cancel,
      onDeletePressed: () async {
        await provider.deleteTrash(trashId: provider.scriptTable[index].id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.current.permanentlyDeleted),
            duration: const Duration(seconds: 2),
          ),
        );
        await provider.updateScriptTable();
      },
    );
  }
}
