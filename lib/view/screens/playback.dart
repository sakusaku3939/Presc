import 'package:flutter/material.dart';
import 'package:presc/view/screens/setting.dart';
import 'package:presc/view/utils/playback_text_view.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:presc/viewModel/playback_provider.dart';
import 'package:provider/provider.dart';

class PlaybackScreen extends StatelessWidget {
  const PlaybackScreen(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: _appbar(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(32, 0, 32, 8),
                child: PlaybackTextView(
                  context.read<ManuscriptProvider>().scriptTable[index].content,
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
                              if (model.playFabState)
                                context
                                    .read<PlaybackProvider>()
                                    .reflectRecognizedText("どこでとんと事だけ");
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
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "原稿1",
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
}
