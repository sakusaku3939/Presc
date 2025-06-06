import 'package:flutter/material.dart';
import 'package:presc/features/manuscript/data/local_backup_service.dart';
import 'package:presc/features/manuscript/ui/providers/manuscript_provider.dart';
import 'package:presc/generated/l10n.dart';
import 'package:provider/provider.dart';

class BackupManuscriptProvider with ChangeNotifier {
  Future<void> onBackupPressed(BuildContext context) async {
    try {
      final path = await LocalBackupService.exportBackupToExternal();

      if (path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.backupSaved)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.backupSaveFailed(e))),
      );
      return;
    }
  }

  Future<void> onRestorePressed(BuildContext context) async {
    final importResult = await LocalBackupService.importBackupData();
    if (importResult == null) {
      return;
    }

    if (!importResult.hasErrors) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.backupRestored)),
      );

      // バックアップ復元後に原稿一覧を再読み込み
      final manuscriptProvider = Provider.of<ManuscriptProvider>(
        context,
        listen: false,
      );
      await manuscriptProvider.updateScriptTable();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.backupRestoreFailed(importResult.errors))),
      );
    }
  }
}
