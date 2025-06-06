import 'package:flutter/material.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/features/setting/ui/widgets/radio_dialog.dart';
import 'package:presc/features/playback/ui/providers/playback_provider.dart';
import 'package:provider/provider.dart';

class ScrollModeDialog {
  static void show(
    BuildContext context, {
    Function(dynamic value)? onChanged,
  }) {
    final playback = context.read<PlaybackProvider>();
    RadioDialog.show(
      context,
      groupValue: playback.scrollMode,
      itemList: [
        RadioDialogItem(
          title: S.current.manualScroll,
          subtitle: S.current.manualScrollDescription,
          value: ScrollMode.manual,
        ),
        RadioDialogItem(
          title: S.current.autoScroll,
          subtitle: S.current.autoScrollDescription,
          value: ScrollMode.auto,
        ),
        RadioDialogItem(
          title: S.current.speechRecognition,
          subtitle: S.current.speechRecognitionDescription,
          value: ScrollMode.recognition,
        ),
      ],
      onChanged: (value) {
        playback.scrollMode = value;
        if (onChanged != null) onChanged(value);
      },
    );
  }
}
