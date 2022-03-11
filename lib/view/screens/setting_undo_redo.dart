import 'package:flutter/material.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/view/utils/dialog/radio_dialog_manager.dart';
import 'package:presc/view/utils/setting_item.dart';
import 'package:presc/viewModel/playback_provider.dart';
import 'package:provider/provider.dart';

class SettingUndoRedoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(),
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
                      RadioDialogManager.show(
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
                    child: SwitchListTile(
                      title: Text("2回タップで元に戻す"),
                      contentPadding: const EdgeInsets.fromLTRB(32, 2, 0, 2),
                      value: model.undoDoubleTap,
                      onChanged: (value) => model.undoDoubleTap = value,
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
}
