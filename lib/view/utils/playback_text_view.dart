import 'dart:async';

import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:presc/config/playback_text_style.dart';
import 'package:presc/config/scroll_speed_config.dart';
import 'package:presc/view/utils/horizontal_text.dart';
import 'package:presc/viewModel/playback_provider.dart';
import 'package:presc/viewModel/playback_timer_provider.dart';
import 'package:presc/viewModel/playback_visualizer_provider.dart';
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
    final visualizer = context.read<PlaybackVisualizerProvider>();
    speech.stop();
    timer.stop();
    WidgetsBinding.instance.addPostFrameCallback((_) => visualizer.reset());
  }

  void reset(BuildContext context) {
    stop(context);
    final provider = context.read<SpeechToTextProvider>();
    provider.recognizedText = "";
    provider.unrecognizedText = _content;
    provider.recognizedLineCount = 0;
  }

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

  void scrollToInit(BuildContext context) =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = context.read<PlaybackProvider>();
        if (provider.scrollVertical)
          _scrollController.jumpTo(0);
        else
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });

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
              playbackProvider: model,
              controller: _scrollController,
              playbackTextKey: _playbackTextKey,
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
    scrollToInit(context);
  }

  Widget _textView(PlaybackProvider model, {autoScroll = false}) {
    if (autoScroll) _autoScroll(model);
    if (model.scrollVertical)
      return Text(
        _content,
        style: PlaybackTextStyle.of(model).unrecognized,
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
    @required this.playbackProvider,
    @required this.controller,
    @required this.playbackTextKey,
  });

  final PlaybackProvider playbackProvider;
  final ScrollController controller;
  final GlobalKey playbackTextKey;

  @override
  Widget build(BuildContext context) {
    return Consumer<SpeechToTextProvider>(
      builder: (context, model, child) {
        _scrollRecognizedText(context, model);
        if (playbackProvider.scrollVertical)
          return Text.rich(
            TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: model.recognizedText,
                  style: PlaybackTextStyle.of(playbackProvider).recognized,
                ),
                TextSpan(
                  text: model.unrecognizedText,
                  style: PlaybackTextStyle.of(playbackProvider).unrecognized,
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

  void _scrollRecognizedText(BuildContext context, SpeechToTextProvider model) {
    if (model.recognizedText.isNotEmpty) {
      final scroll = controller;
      final RenderBox box = playbackTextKey.currentContext?.findRenderObject();
      if (playbackProvider.scrollVertical) {
        final height = _textBoxSize(
          model.recognizedText,
          box?.size?.width,
          model.recognizedLineCount,
        );
        _scrollTo(
          height - 88,
          limit: scroll.offset < scroll.position.maxScrollExtent,
        );
      } else {
        final width = _textBoxSize(
          model.recognizedText,
          box?.size?.height,
          model.recognizedLineCount,
        );
        _scrollTo(
          scroll.position.maxScrollExtent - width,
          limit: scroll.offset > 0,
        );
      }
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

  double _textBoxSize(String text, double textWidth, int recognizedLineCount) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text.replaceAll('\n', ''),
        style: PlaybackTextStyle.of(playbackProvider).calculation,
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    textWidth ??= 1;
    final rowCount = (textPainter.size.width / textWidth).ceil();
    final height = rowCount * textPainter.size.height;
    return height + recognizedLineCount * 18;
  }
}
