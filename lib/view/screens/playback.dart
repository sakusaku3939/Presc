import 'package:flutter/material.dart';
import 'package:presc/view/screens/setting.dart';
import 'package:presc/view/utils/playback_text_view.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:presc/viewModel/playback_provider.dart';
import 'package:presc/viewModel/playback_visualizer_provider.dart';
import 'package:presc/viewModel/speech_to_text_provider.dart';
import 'package:provider/provider.dart';

class PlaybackScreen extends StatelessWidget {
  const PlaybackScreen(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<SpeechToTextProvider>().back(context);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: _appbar(context),
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
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(32, 0, 32, 8),
                      child: PlaybackTextView(
                        context
                            .read<ManuscriptProvider>()
                            .scriptTable[index]
                            .content,
                      ),
                    ),
                  ),
                  Text(
                    "0:17",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Consumer<PlaybackProvider>(
                    builder: (context, model, child) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(32, 12, 32, 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 48,
                              child: RippleIconButton(
                                Icons.mic,
                                size: 28,
                                color: Colors.white,
                                onPressed: () => {},
                              ),
                            ),
                            Container(
                              width: 48,
                              child: RippleIconButton(
                                Icons.skip_previous_outlined,
                                size: 32,
                                color: Colors.white,
                                onPressed: () => {},
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
                                    PlaybackTextView.reset(context);
                                    final provider =
                                        context.read<SpeechToTextProvider>();
                                    if (model.playFabState) {
                                      provider.start(context);
                                    } else {
                                      provider.stop();
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
                                color: Colors.white,
                                onPressed: () => {},
                              ),
                            ),
                            Container(
                              width: 48,
                              child: RippleIconButton(
                                Icons.text_rotate_vertical,
                                size: 28,
                                color: Colors.white,
                                onPressed: () => {},
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[900],
      centerTitle: true,
      elevation: 0,
      leading: RippleIconButton(
        Icons.navigate_before,
        color: Colors.white,
        size: 32,
        onPressed: () => context.read<SpeechToTextProvider>().back(context),
      ),
      title: Text(
        context.read<ManuscriptProvider>().scriptTable[index].title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 4),
          child: RippleIconButton(
            Icons.settings,
            color: Colors.white,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingScreen()),
            ),
          ),
        ),
      ],
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
                color: Colors.red.withOpacity(.8),
              ),
          ],
        );
      },
    );
  }
}
