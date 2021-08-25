import 'dart:async';

import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:presc/config/playback_text_style.dart';
import 'package:presc/config/scroll_speed_config.dart';
import 'package:presc/view/utils/horizontal_text.dart';
import 'package:presc/viewModel/playback_provider.dart';
import 'package:presc/viewModel/playback_timer_provider.dart';
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

  void stop(BuildContext context) {
    final speech = context.read<SpeechToTextProvider>();
    final timer = context.read<PlaybackTimerProvider>();
    speech.stop();
    timer.stop();
  }

  void reset(BuildContext context) {
    stop(context);
    final provider = context.read<SpeechToTextProvider>();
    provider.recognizedText = "";
    provider.unrecognizedText = _content;
  }

  void jumpTo(double value) => _scrollController.jumpTo(value);

  void scrollToStart() => _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );

  void scrollToEnd() => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );

  @override
  Widget build(BuildContext context) {
    _init(context);
    return Consumer<PlaybackProvider>(
      builder: (context, model, child) {
        Widget playbackText;
        switch (model.scrollMode) {
          case ScrollMode.manual:
            playbackText = _textView(model, autoScroll: false);
            break;
          case ScrollMode.auto:
            playbackText = _textView(model, autoScroll: true);
            break;
          case ScrollMode.recognition:
            playbackText = _RecognizedTextView(
              controller: _scrollController,
              playbackTextKey: _playbackTextKey,
              scrollVertical: model.scrollVertical,
            );
            break;
        }
        return NotificationListener(
          onNotification: (notification) {
            if (model.scrollMode == ScrollMode.auto)
              _returnToScroll(notification, model);
            return true;
          },
          child: FadingEdgeScrollView.fromSingleChildScrollView(
            gradientFractionOnStart: gradientFraction,
            gradientFractionOnEnd: gradientFraction,
            child: SingleChildScrollView(
              scrollDirection:
                  model.scrollVertical ? Axis.vertical : Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: playbackText,
              ),
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
      if (provider.scrollVertical)
        jumpTo(0);
      else
        jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  Widget _textView(PlaybackProvider model, {autoScroll = false}) {
    if (autoScroll) _autoScroll(model);
    if (model.scrollVertical)
      return Text(
        _content,
        style: PlaybackTextStyle.unrecognized(PlaybackAxis.vertical),
        key: _playbackTextKey,
      );
    else
      return HorizontalText(
        key: _playbackTextKey,
        recognizedText: "",
        unrecognizedText: _content,
      );
  }

  void _autoScroll(PlaybackProvider model) {
    if (_scrollController.hasClients) {
      final speed = ScrollSpeedConfig.kSpeed * model.scrollSpeedMagnification;
      final offset = _scrollController.offset;
      final maxExtent = _scrollController.position.maxScrollExtent;
      final distance = model.scrollVertical ? maxExtent - offset : offset;
      final durationDouble = distance / speed;

      if (distance <= 0) return;

      if (model.playFabState)
        _scrollController?.animateTo(
          model.scrollVertical ? maxExtent : 0,
          duration: Duration(seconds: durationDouble.toInt()),
          curve: Curves.linear,
        );
      else
        _scrollController.animateTo(
          offset,
          duration: Duration(milliseconds: 1),
          curve: Curves.linear,
        );
    }
  }

  void _returnToScroll(Notification notification, PlaybackProvider model) {
    if (notification is ScrollEndNotification && model.playFabState) {
      Timer(Duration(seconds: 1), () {
        _autoScroll(model);
      });
    }
  }
}

class _RecognizedTextView extends StatelessWidget {
  const _RecognizedTextView({
    @required this.controller,
    @required this.playbackTextKey,
    @required this.scrollVertical,
  });

  final ScrollController controller;
  final GlobalKey playbackTextKey;
  final bool scrollVertical;

  @override
  Widget build(BuildContext context) {
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
            key: playbackTextKey,
          );
        else
          return HorizontalText(
            key: playbackTextKey,
            recognizedText: model.recognizedText,
            unrecognizedText: model.unrecognizedText,
          );
      },
    );
  }

  void _scrollRecognizedText(BuildContext context, String recognizedText) {
    if (recognizedText.isNotEmpty) {
      final scroll = controller;
      final RenderBox box = playbackTextKey.currentContext?.findRenderObject();
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
      controller.animateTo(
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
