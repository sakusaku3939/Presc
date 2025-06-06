import 'package:flutter/material.dart';
import 'package:presc/features/setting/ui/providers/backup_manuscript_provider.dart';
import 'package:presc/features/setting/ui/widgets/setting_item.dart';
import 'package:presc/shared/widgets/button/ripple_button.dart';
import 'package:provider/provider.dart';

class BackupManuscriptPage extends StatelessWidget {
  const BackupManuscriptPage({super.key});

  @override
  Widget build(BuildContext context) {
    final backupProvider = Provider.of<BackupManuscriptProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _appbar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 8),
              SettingItem(
                title: "原稿をエクスポート",
                subtitle: "外部ストレージに原稿をバックアップする",
                onTap: () => backupProvider.onBackupPressed(context),
              ),
              SettingItem(
                title: "原稿をインポート",
                subtitle: "バックアップファイルから原稿を復元する",
                onTap: () => backupProvider.onRestorePressed(context),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      elevation: 1,
      leading: RippleIconButton(
        Icons.navigate_before,
        size: 32,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
