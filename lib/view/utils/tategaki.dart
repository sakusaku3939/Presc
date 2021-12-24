import 'package:flutter/material.dart';
import 'package:presc/viewModel/speech_to_text_provider.dart';
import 'package:provider/provider.dart';
import 'package:presc/config/vertical_rotated.dart';
import 'package:presc/config/playback_text_style.dart';
import 'package:presc/viewModel/playback_provider.dart';

class Tategaki extends StatelessWidget {
  Tategaki({
    Key key,
    @required this.recognizedText,
    @required this.unrecognizedText,
  }) : super(key: key);

  final String recognizedText;
  final String unrecognizedText;

  @override
  Widget build(BuildContext context) {
    final length = recognizedText.replaceAll('\n', '').length;
    final split = (recognizedText + unrecognizedText).split("\n");
    List<Widget> list = [];
    int totalSplitLength = 0;

    for (int i = 0; i < split.length; i++) {
      list.add(
        _textBoxWidget(context, split[i].runes, length - totalSplitLength),
      );
      totalSplitLength += split[i].length;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        _calcRecognizedWidth(context, constraints);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: list,
        );
      },
    );
  }

  Widget _textBoxWidget(BuildContext context, Runes runes, int distance) {
    final provider = context.read<PlaybackProvider>();
    final textBox = (String char, bool recognized) => Row(
          children: [
            _characterWidget(
              provider,
              char,
              recognized: recognized,
            ),
            SizedBox(
              width:
                  provider.fontHeight * provider.fontSize - provider.fontSize,
            ),
          ],
        );
    int i = 0;
    List<Widget> recognizedList = [];
    List<Widget> unrecognizedList = [];

    for (var rune in runes) {
      if (i - distance < 0)
        recognizedList.add(textBox(String.fromCharCode(rune), true));
      else
        unrecognizedList.add(textBox(String.fromCharCode(rune), false));
      i++;
    }

    return Wrap(
      textDirection: TextDirection.rtl,
      direction: Axis.vertical,
      children: recognizedList + unrecognizedList,
    );
  }

  Widget _characterWidget(
    PlaybackProvider provider,
    String char, {
    bool recognized = false,
  }) {
    final config = PlaybackTextStyle.of(provider);
    final style = recognized ? config.recognized : config.unrecognized;
    if (VerticalRotated.map[char] != null) {
      return Text(VerticalRotated.map[char], style: style);
    } else {
      return Text(char, style: style);
    }
  }

  void _calcRecognizedWidth(BuildContext context, BoxConstraints constraints) {
    final provider = context.read<PlaybackProvider>();
    final lineChar = constraints.maxHeight ~/ (provider.fontSize * 1.2);
    final recognizedLine = (recognizedText.length / lineChar).ceil();
    final width = recognizedLine * provider.fontHeight * provider.fontSize +
        provider.fontSize;
    context.read<SpeechToTextProvider>().verticalRecognizedWidth = width;
  }
}
