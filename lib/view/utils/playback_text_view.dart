import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:presc/view/utils/horizontal_text.dart';
import 'package:presc/viewModel/playback_provider.dart';
import 'package:presc/viewModel/speech_to_text_provider.dart';
import 'package:provider/provider.dart';

class PlaybackTextView extends StatelessWidget {
  PlaybackTextView(
    this.text, {
    this.gradientFraction = 0.2,
  });

  final String text;
  final double gradientFraction;

  static String _content;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _richTextKey = GlobalKey();

  static void reset(BuildContext context) {
    final provider = context.read<SpeechToTextProvider>();
    provider.recognizedText = "";
    provider.unrecognizedText = _content;
  }

  @override
  Widget build(BuildContext context) {
    _init(context);
    return Selector<PlaybackProvider, bool>(
      selector: (_, model) => model.scrollVertical,
      builder: (context, scrollVertical, child) {
        return FadingEdgeScrollView.fromSingleChildScrollView(
          gradientFractionOnStart: gradientFraction,
          gradientFractionOnEnd: gradientFraction,
          child: SingleChildScrollView(
            scrollDirection: scrollVertical ? Axis.vertical : Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: _playbackText(scrollVertical),
            ),
          ),
        );
      },
    );
  }

  void _init(BuildContext context) {
    _content = text;
    reset(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PlaybackProvider>();
      context.read<PlaybackProvider>().scrollController = _scrollController;
      _scrollController.jumpTo(
        provider.scrollVertical
            ? 0
            : _scrollController.position.maxScrollExtent,
      );
    });
  }

  Widget _playbackText(bool scrollVertical) {
    return Consumer<SpeechToTextProvider>(
      builder: (context, model, child) {
        _scrollRecognizedText(context, model.recognizedText);
        return scrollVertical
            ? Text.rich(
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
              )
            : HorizontalText(model.unrecognizedText);
      },
    );
  }

  void _scrollRecognizedText(BuildContext context, String recognizedText) {
    if (recognizedText.isNotEmpty) {
      final scroll = _scrollController;
      final RenderBox box = _richTextKey.currentContext?.findRenderObject();
      if (scroll.offset < scroll.position.maxScrollExtent) {
        scroll.animateTo(
          _textHeight(recognizedText, box?.size?.width) - 88,
          duration: Duration(milliseconds: 1000),
          curve: Curves.ease,
        );
      }
    }
  }

  double _textHeight(String text, double textWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text.replaceAll('\n', ''),
        style: TextStyle(
          height: 2.2,
          fontSize: 20,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    textWidth ??= 1;
    final lfCount = '\n'.allMatches(text).length * 0.5;
    final countLines = (textPainter.size.width / textWidth + lfCount).ceil();
    final height = countLines * textPainter.size.height;
    return height;
  }
}
