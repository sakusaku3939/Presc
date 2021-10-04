import 'dart:math';
import 'package:flutter/material.dart';
import 'package:presc/view/screens/setting.dart';
import 'package:presc/view/utils/playback_text_view.dart';
import 'package:presc/view/utils/dialog/radio_dialog_manager.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/viewModel/playback_provider.dart';
import 'package:presc/viewModel/playback_timer_provider.dart';
import 'package:presc/viewModel/playback_visualizer_provider.dart';
import 'package:presc/viewModel/speech_to_text_provider.dart';
import 'package:provider/provider.dart';

class PlaybackScreen extends StatelessWidget {
  PlaybackScreen({@required this.title, @required this.content});

  final String title;
  final String content;

  void _back(BuildContext context) {
    context.read<SpeechToTextProvider>().back(context);
    context.read<PlaybackTimerProvider>().reset();
  }

  @override
  Widget build(BuildContext context) {
    final playbackTextView = PlaybackTextView(content);
    return WillPopScope(
      onWillPop: () {
        _back(context);
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
                      child: _visualizer(),
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: playbackTextView,
                      ),
                      Selector<PlaybackTimerProvider, String>(
                        selector: (_, model) => model.time,
                        builder: (context, time, child) {
                          return Text(
                            time,
                            style: TextStyle(
                              color: model.textColor,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
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

  Widget _appbar(BuildContext context, PlaybackProvider model) {
    return AppBar(
      backgroundColor: model.backgroundColor,
      centerTitle: true,
      elevation: 0,
      leading: RippleIconButton(
        Icons.navigate_before,
        color: model.textColor,
        size: 32,
        onPressed: () => _back(context),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: model.textColor,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 4),
          child: RippleIconButton(
            Icons.settings,
            color: model.textColor,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingScreen()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _operationMenu(BuildContext context, PlaybackProvider model,
      PlaybackTextView playbackTextView) {
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

    return Padding(
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
              onPressed: () => {
                RadioDialogManager.show(
                  context,
                  groupValue: model.scrollMode,
                  itemList: [
                    RadioDialogItem(
                      title: "手動スクロール",
                      subtitle: "スクロールを行いません",
                      value: ScrollMode.manual,
                    ),
                    RadioDialogItem(
                      title: "自動スクロール",
                      subtitle: "一定の速度でスクロールします",
                      value: ScrollMode.auto,
                    ),
                    RadioDialogItem(
                      title: "音声認識",
                      subtitle: "認識した文字分だけスクロールします",
                      value: ScrollMode.recognition,
                    ),
                  ],
                  onChanged: (value) {
                    model.scrollMode = value;
                    model.playFabState = false;
                    playbackTextView.reset(context);
                  },
                )
              },
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
                if (model.scrollVertical) timer.reset();
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
                child: model.playFabState
                    ? Icon(Icons.pause)
                    : Icon(Icons.play_arrow),
                onPressed: () {
                  model.playFabState = !model.playFabState;
                  if (model.playFabState) {
                    if (model.scrollMode == ScrollMode.recognition) {
                      speech.start(context);
                    }
                    timer.start();
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
                if (!model.scrollVertical) timer.reset();
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
              model.scrollVertical
                  ? Icons.text_rotate_vertical
                  : Icons.text_rotation_none,
              size: 28,
              color: model.textColor,
              onPressed: () {
                model.scrollVertical = !model.scrollVertical;
                model.playFabState = false;
                playbackTextView.stop(context);
                playbackTextView.scrollToInit(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _visualizer() {
    return Consumer<PlaybackVisualizerProvider>(
      builder: (context, model, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (int i = 0; i < PlaybackVisualizerProvider.barSize; i++)
              Container(
                width: model.width(context),
                height: model.height[i],
                color: Colors.red.withOpacity(_easeIn(model.level / 10)),
              )
          ],
        );
      },
    );
  }

  double _easeIn(double x) => x * x;
}
