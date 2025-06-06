import 'package:flutter/material.dart';
import 'package:presc/features/playback/ui/providers/playback_visualizer_provider.dart';
import 'package:provider/provider.dart';

class PlaybackVisualizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final playbackVisualizer = context.read<PlaybackVisualizerProvider>();
        playbackVisualizer.init(context);
        return visualizer();
      },
    );
  }

  Widget visualizer() {
    return Consumer<PlaybackVisualizerProvider>(
      builder: (context, model, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (int i = 0; i < model.barSize; i++) bar(model, i),
          ],
        );
      },
    );
  }

  Widget bar(PlaybackVisualizerProvider model, int i) {
    return Container(
      width: model.barWidth,
      height: model.barHeight[i],
      color: Colors.red.withOpacity(_easeIn(model.volume / 10)),
    );
  }

  double _easeIn(double x) => x * x;
}
