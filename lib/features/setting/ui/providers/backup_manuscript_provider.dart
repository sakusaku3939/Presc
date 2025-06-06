import 'package:flutter/material.dart';
import 'package:presc/features/manuscript/data/local_backup_service.dart';
import 'package:presc/features/manuscript/ui/providers/manuscript_provider.dart';
import 'package:provider/provider.dart';

class BackupManuscriptProvider with ChangeNotifier {
  Future<void> onBackupPressed(BuildContext context) async {
    try {
      final path = await LocalBackupService.exportBackupToExternal();

      if (path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('原稿のバックアップが保存されました')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('バックアップの保存に失敗しました: $e')),
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
        SnackBar(content: Text("原稿のバックアップが復元されました")),
      );

      // バックアップ復元後に原稿一覧を再読み込み
      final manuscriptProvider = Provider.of<ManuscriptProvider>(
        context,
        listen: false,
      );
      await manuscriptProvider.updateScriptTable();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("バックアップの復元に失敗しました: ${importResult.errors}")),
      );
    }
  }
}
