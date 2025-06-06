import 'package:flutter/material.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/features/setting/ui/widgets/radio_dialog.dart';
import 'package:presc/shared/widgets/ripple_button.dart';
import 'package:presc/features/setting/ui/widgets/platform_switch.dart';
import 'package:presc/features/setting/ui/widgets/setting_item.dart';
import 'package:presc/features/playback/ui/providers/playback_provider.dart';
import 'package:provider/provider.dart';

class SettingUndoRedoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _appbar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<PlaybackProvider>(
            builder: (context, model, child) {
              return Column(
                children: [
                  SizedBox(height: 8),
                  SettingItem(
                    title: S.current.undoRedoButton,
                    subtitle:
                        model.showUndoRedo ? S.current.show : S.current.hide,
                    onTap: () => {
                      RadioDialog.show(
                        context,
                        groupValue: model.showUndoRedo,
                        itemList: [
                          RadioDialogItem(
                            title: S.current.show,
                            value: true,
                          ),
                          RadioDialogItem(
                            title: S.current.hide,
                            value: false,
                          ),
                        ],
                        onChanged: (value) => model.showUndoRedo = value,
                      )
                    },
                  ),
                  Ink(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(S.current.undoDoubleTap),
                      contentPadding: const EdgeInsets.fromLTRB(32, 2, 12, 2),
                      trailing: PlatformSwitch(
                        value: model.undoDoubleTap,
                        onChanged: (value) => model.undoDoubleTap = value,
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              );
            },
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
