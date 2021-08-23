import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:presc/config/playback_text_style.dart';
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
  final GlobalKey _playbackTextKey = GlobalKey();

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
      provider.scrollController = _scrollController;
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
        if (scrollVertical)
          return Text.rich(
            TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: model.recognizedText,
                  style: PlaybackTextStyle.recognized(PlaybackAxis.vertical),
                ),
                TextSpan(
                  text: model.unrecognizedText,
                  style: PlaybackTextStyle.unrecognized(PlaybackAxis.vertical),
                ),
              ],
            ),
            key: _playbackTextKey,
          );
        else
          return HorizontalText(
            key: _playbackTextKey,
            recognizedText: model.recognizedText,
            unrecognizedText: model.unrecognizedText,
          );
      },
    );
  }

  void _scrollRecognizedText(BuildContext context, String recognizedText) {
    if (recognizedText.isNotEmpty) {
      final scroll = _scrollController;
      final RenderBox box = _playbackTextKey.currentContext?.findRenderObject();
      if (context.read<PlaybackProvider>().scrollVertical)
        _scrollTo(
          _textHeight(recognizedText, box?.size?.width) - 88,
          limit: scroll.offset < scroll.position.maxScrollExtent,
        );
      else
        _scrollTo(
          scroll.position.maxScrollExtent -
              _textHeight(recognizedText, box?.size?.height) +
              44,
          limit: scroll.offset > 0,
        );
    }
  }

  void _scrollTo(double offset, {bool limit}) {
    if (limit)
      _scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 1000),
        curve: Curves.ease,
      );
  }

  double _textHeight(String text, double textWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text.replaceAll('\n', ''),
        style: PlaybackTextStyle.recognized(PlaybackAxis.vertical),
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
