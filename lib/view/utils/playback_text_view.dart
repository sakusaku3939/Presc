import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:presc/viewModel/playback_provider.dart';
import 'package:provider/provider.dart';

class PlaybackTextView extends StatelessWidget {
  PlaybackTextView(
    this.text, {
    this.height,
    this.scroll = true,
    this.gradientFraction = 0.2,
  });

  static String content;

  final String text;
  final double height;
  final bool scroll;
  final double gradientFraction;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (scroll) content = text;
    reset(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(scroll ? 0 : 24);
    });
    return Container(
      height: height,
      child: FadingEdgeScrollView.fromSingleChildScrollView(
        gradientFractionOnStart: gradientFraction,
        gradientFractionOnEnd: gradientFraction,
        child: SingleChildScrollView(
          physics: (scroll)
              ? BouncingScrollPhysics()
              : NeverScrollableScrollPhysics(),
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Consumer<PlaybackProvider>(
              builder: (context, model, child) {
                return Text.rich(
                  TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                        text: model.recognizedText,
                        style: TextStyle(
                          color: DefaultTextStyle.of(context).style.color,
                          backgroundColor: Colors.grey[100],
                          height: 2.2,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text: model.unrecognizedText,
                        style: TextStyle(
                          color: Colors.white,
                          height: 2.2,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  static void reset(BuildContext context) {
    final provider = context.read<PlaybackProvider>();
    provider.recognizedText = "";
    provider.unrecognizedText = content;
  }
}
