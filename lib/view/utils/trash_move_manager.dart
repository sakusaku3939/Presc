import 'package:flutter/material.dart';
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
        content: Text("ごみ箱に移動しました"),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "元に戻す",
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
        content: Text(
          "空の原稿を削除しました",
        ),
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
        content: Text(
          "ごみ箱から復元しました",
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "元に戻す",
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
      content: Text("${title.isNotEmpty ? title : "(タイトルなし)"}を完全に削除しますか？"),
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
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
