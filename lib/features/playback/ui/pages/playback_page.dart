import 'package:flutter/material.dart';
import 'package:presc/features/setting/ui/pages/setting_page.dart';
import 'package:presc/features/playback/ui/widgets/scroll_mode_dialog.dart';
import 'package:presc/features/playback/ui/widgets/playback_text_view.dart';
import 'package:presc/features/playback/ui/widgets/playback_visualizer.dart';
import 'package:presc/shared/widgets/ripple_button.dart';
import 'package:presc/features/playback/ui/providers/playback_provider.dart';
import 'package:presc/features/playback/ui/providers/playback_timer_provider.dart';
import 'package:presc/features/playback/ui/providers/speech_to_text_provider.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import '../../../../core/constants/color_constants.dart';

class PlaybackPage extends StatelessWidget {
  PlaybackPage({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final playbackTextView = PlaybackTextView(content);
    return WillPopScope(
      onWillPop: () {
        final speech = context.read<SpeechToTextProvider>();
        speech.back(context);
        return Future.value(false);
      },
      child: Consumer<PlaybackProvider>(
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: model.backgroundColor,
            appBar: _appbar(context, model),
            body: SafeArea(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: IgnorePointer(
                      ignoring: true,
                      child: PlaybackVisualizer(),
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Column(
                            children: [
                              Expanded(child: playbackTextView),
                              _timer(context, model),
                            ],
                          ),
                          onDoubleTap: () async {
                            final speech = context.read<SpeechToTextProvider>();
                            if (model.undoDoubleTap && speech.canUndo) {
                              speech.undo();
                              final hasCustomVibrations =
                                  await Vibration.hasCustomVibrationsSupport();
                              if (hasCustomVibrations == true) {
                                Vibration.vibrate(duration: 10);
                              }
                            }
                          },
                        ),
                      ),
                      _operationMenu(context, model, playbackTextView),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _appbar(BuildContext context, PlaybackProvider model) {
    return AppBar(
      backgroundColor: model.backgroundColor,
      centerTitle: true,
      elevation: 0,
      titleSpacing: 0,
      leading: RippleIconButton(
        Icons.navigate_before,
        color: model.textColor,
        size: 32,
        onPressed: () => context.read<SpeechToTextProvider>().back(context),
      ),
      title: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              SizedBox(width: constraints.maxWidth > 400 ? 72 : 0),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: model.textColor,
                    ),
                  ),
                ),
              ),
              _undoRedoButton(context, model),
            ],
          );
        },
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 4),
          child: RippleIconButton(
            Icons.settings,
            color: model.textColor,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingPage()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _undoRedoButton(BuildContext context, PlaybackProvider provider) {
    if (provider.showUndoRedo)
      return Consumer<SpeechToTextProvider>(
        builder: (context, model, child) {
          return Row(
            children: [
              Container(
                width: 36,
                child: RippleIconButton(
                  Icons.undo,
                  size: 18,
                  color: provider.textColor,
                  disabledColor: Colors.white30,
                  onPressed: model.canUndo ? () => model.undo() : null,
                ),
              ),
              Container(
                width: 36,
                child: RippleIconButton(
                  Icons.redo,
                  size: 18,
                  color: provider.textColor,
                  disabledColor: Colors.white30,
                  onPressed: model.canRedo ? () => model.redo() : null,
                ),
              ),
            ],
          );
        },
      );
    else
      return Container();
  }

  Widget _timer(BuildContext context, PlaybackProvider playback) {
    return Consumer<SpeechToTextProvider>(
      builder: (context, model, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: model.isProcessing ? 16 : 0,
              ),
              child: Selector<PlaybackTimerProvider, String>(
                selector: (_, model) => model.time,
                builder: (context, time, child) {
                  return Text(
                    time,
                    style: TextStyle(
                      color: playback.textColor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            if (model.isProcessing)
              Container(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: ColorConstants.mainColor,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _operationMenu(
    BuildContext context,
    PlaybackProvider model,
    PlaybackTextView playbackTextView,
  ) {
    final speech = context.read<SpeechToTextProvider>();
    final timer = context.read<PlaybackTimerProvider>();

    IconData scrollModeIcon;
    switch (model.scrollMode) {
      case ScrollMode.manual:
        scrollModeIcon = Icons.touch_app_outlined;
        break;
      case ScrollMode.auto:
        scrollModeIcon = Icons.loop;
        break;
      case ScrollMode.recognition:
        scrollModeIcon = Icons.mic;
        break;
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 700,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 12, 32, 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 48,
              child: RippleIconButton(
                scrollModeIcon,
                size: 28,
                color: model.textColor,
                onPressed: () => ScrollModeDialog.show(
                  context,
                  onChanged: (_) {
                    model.playFabState = false;
                    playbackTextView.reset(context);
                  },
                ),
              ),
            ),
            Container(
              width: 48,
              child: RippleIconButton(
                Icons.skip_previous_outlined,
                size: 32,
                color: model.textColor,
                onPressed: () {
                  playbackTextView.reset(context);
                  playbackTextView.scrollToStart();
                  if (model.scrollHorizontal) timer.reset();
                  Future.delayed(
                    Duration(milliseconds: 300),
                    () => model.playFabState = false,
                  );
                },
              ),
            ),
            Container(
              width: 64,
              child: FittedBox(
                child: FloatingActionButton(
                  backgroundColor: ColorConstants.mainColor,
                  shape: const CircleBorder(),
                  child: model.playFabState
                      ? Icon(Icons.pause, color: Colors.white)
                      : Icon(Icons.play_arrow, color: Colors.white),
                  onPressed: () {
                    model.playFabState = !model.playFabState;
                    if (model.playFabState) {
                      if (model.scrollMode == ScrollMode.recognition) {
                        speech.start(context);
                      } else {
                        timer.start();
                      }
                    } else {
                      playbackTextView.stop(context);
                    }
                  },
                ),
              ),
            ),
            Container(
              width: 48,
              child: RippleIconButton(
                Icons.skip_next_outlined,
                size: 32,
                color: model.textColor,
                onPressed: () {
                  playbackTextView.reset(context);
                  playbackTextView.scrollToEnd();
                  if (!model.scrollHorizontal) timer.reset();
                  Future.delayed(
                    Duration(milliseconds: 300),
                    () => model.playFabState = false,
                  );
                },
              ),
            ),
            Container(
              width: 48,
              child: RippleIconButton(
                model.scrollHorizontal
                    ? Icons.text_rotate_vertical
                    : Icons.text_rotation_none,
                size: 28,
                color: model.textColor,
                onPressed: () {
                  model.scrollHorizontal = !model.scrollHorizontal;
                  model.playFabState = false;
                  playbackTextView.stop(context);
                  playbackTextView.scrollToInit(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
