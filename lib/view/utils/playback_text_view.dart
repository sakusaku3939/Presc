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
  final GlobalKey _richTextKey = GlobalKey();

  static void reset(BuildContext context) {
    final provider = context.read<PlaybackProvider>();
    provider.recognizedText = "";
    provider.unrecognizedText = content;
  }

  @override
  Widget build(BuildContext context) {
    _init(context);
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
            child: _playbackText(),
          ),
        ),
      ),
    );
  }

  void _init(BuildContext context) {
    if (scroll) content = text;
    reset(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(scroll ? 0 : 24);
    });
  }

  Widget _playbackText() {
    return Consumer<PlaybackProvider>(
      builder: (context, model, child) {
        final recognizedTextSpan = TextSpan(
          text: model.recognizedText,
          style: TextStyle(
            backgroundColor: Colors.grey[100],
            height: 2.2,
            fontSize: 20,
          ),
        );
        _scrollRecognizedText(model.recognizedText, recognizedTextSpan);

        return Text.rich(
          TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                text: model.recognizedText,
                style: TextStyle(
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
          key: _richTextKey,
        );
      },
    );
  }

  void _scrollRecognizedText(String recognizedText, TextSpan textSpan) {
    if (recognizedText.isNotEmpty) {
      final RenderBox box = _richTextKey.currentContext?.findRenderObject();
      _scrollController.animateTo(
        _textHeight(textSpan, box?.size?.width) - 88,
        duration: Duration(milliseconds: 1000),
        curve: Curves.ease,
      );
    }
  }

  double _textHeight(TextSpan textSpan, double textWidth) {
    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    textWidth ??= 1;
    final lfCount = '\n'.allMatches(textSpan.text).length * 0.5;
    final countLines = (textPainter.size.width / textWidth + lfCount).ceil();
    final height = countLines * textPainter.size.height;
    return height;
  }
}
