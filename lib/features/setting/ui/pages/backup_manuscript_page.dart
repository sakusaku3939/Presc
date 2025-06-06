import 'package:flutter/material.dart';
import 'package:presc/features/setting/ui/providers/backup_manuscript_provider.dart';
import 'package:presc/features/setting/ui/widgets/setting_item.dart';
import 'package:presc/generated/l10n.dart';
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
                leading: Icon(Icons.backup),
                title: S.current.backupManuscript,
                subtitle: S.current.backupManuscriptDescription,
                onTap: () => backupProvider.onBackupPressed(context),
              ),
              SettingItem(
                leading: Icon(Icons.restore),
                title: S.current.restoreManuscript,
                subtitle: S.current.restoreManuscriptDescription,
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
      title: Text(
        S.current.backup,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
