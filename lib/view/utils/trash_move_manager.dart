import 'package:flutter/material.dart';
import 'package:presc/viewModel/manuscript_provider.dart';

import 'dialog_manager.dart';

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
        content: Text(
          "ごみ箱に移動しました",
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "元に戻す",
          onPressed: () async {
            await provider.restoreFromTrash(trashId: newId);
            await provider.updateScriptTable();
            provider.insertScriptItem(index);
          },
        ),
      ),
    );
    provider.removeScriptItem(index);
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
        content: Text(
          "ごみ箱から復元しました",
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "元に戻す",
          onPressed: () async {
            await provider.moveToTrash(memoId: newId);
            await provider.updateScriptTable();
            provider.insertScriptItem(index);
          },
        ),
      ),
    );
    provider.removeScriptItem(index);
    await provider.updateScriptTable();
  }

  static Future<void> delete({
    @required BuildContext context,
    @required ManuscriptProvider provider,
    @required int index,
  }) async {
    DialogManager.show(
      context,
      content: Text("${provider.scriptTable[index].title}を完全に削除しますか？"),
      actions: [
        DialogTextButton(
          "キャンセル",
          onPressed: () => Navigator.pop(context),
        ),
        DialogTextButton(
          "削除",
          onPressed: () async {
            await provider.deleteTrash(trashId: provider.scriptTable[index].id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "完全に削除しました",
                ),
                duration: const Duration(seconds: 2),
              ),
            );
            await provider.updateScriptTable();
            provider.removeScriptItem(index);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
