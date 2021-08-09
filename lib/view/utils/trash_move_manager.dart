import 'package:flutter/material.dart';
import 'package:presc/viewModel/manuscript_provider.dart';

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
}
