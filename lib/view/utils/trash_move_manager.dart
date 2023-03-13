import 'package:flutter/material.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/view/utils/dialog/platform_dialog_manager.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:provider/provider.dart';

class TrashMoveManager {
  static Future<void> moveToTrash({
    required BuildContext context,
    required int id,
  }) async {
    final script = context.read<ManuscriptProvider>();
    final newId = await script.moveToTrash(memoId: id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.current.trashMoved),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: S.current.undo,
          onPressed: () async {
            await script.restoreFromTrash(trashId: newId);
            await script.updateScriptTable();
          },
        ),
      ),
    );
    await script.updateScriptTable();
  }

  static Future<void> deleteEmpty({
    required BuildContext context,
    required int id,
  }) async {
    final script = context.read<ManuscriptProvider>();
    await script.moveToTrash(memoId: id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.current.emptyScriptDeleted),
        duration: const Duration(seconds: 3),
      ),
    );
    await script.updateScriptTable();
  }

  static Future<void> restore({
    required BuildContext context,
    required int id,
  }) async {
    final script = context.read<ManuscriptProvider>();
    final newId = await script.restoreFromTrash(trashId: id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.current.trashRestored),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: S.current.undo,
          onPressed: () async {
            await script.moveToTrash(memoId: newId);
            await script.updateScriptTable();
          },
        ),
      ),
    );
    await script.updateScriptTable();
  }

  static Future<void> delete({
    required BuildContext context,
    required int id,
    required String title,
  }) async {
    await PlatformDialogManager.showDeleteAlert(
      context,
      message: S.current.doDeletePermanently(
        (title.isNotEmpty) ? title : "(${S.current.noTitle})",
      ),
      deleteLabel: S.current.delete,
      cancelLabel: S.current.cancel,
      onDeletePressed: () async {
        final script = context.read<ManuscriptProvider>();
        await script.deleteTrash(trashId: id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.current.permanentlyDeleted),
            duration: const Duration(seconds: 2),
          ),
        );
        await script.updateScriptTable();
      },
    );
  }
}
