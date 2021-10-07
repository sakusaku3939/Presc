import 'package:flutter/material.dart';
import 'package:presc/config/playback_text_style.dart';
import 'package:presc/viewModel/playback_provider.dart';
import 'package:provider/provider.dart';

class HorizontalText extends StatelessWidget {
  HorizontalText({
    Key key,
    @required this.recognizedText,
    @required this.unrecognizedText,
    this.horizontalRecognizedListener,
  }) : super(key: key);

  final String recognizedText;
  final String unrecognizedText;
  final void Function(double width) horizontalRecognizedListener;

  final _punctuation = [
    '。',
    '、',
  ];
  final _rotateList = {
    'ー': '丨',
    '~': '≀',
    '～': '≀',
    '.': '・',
    '…': '︙',
    '(': '︵',
    ')': '︶',
    '（': '︵',
    '）': '︶',
    '{': '︷',
    '}': '︸',
    '｛': '︷',
    '｝': '︸',
    '[': '﹇',
    ']': '﹈',
    '「': '﹁',
    '」': '﹂',
    '『』': '︺',
    '〈': '︿',
    '〉': '﹀',
    '<': '︿',
    '>': '﹀',
    '《': '︽',
    '》': '︾',
    '«': '︽',
    '»': '︾',
    '〔': '︹',
    '〕': '︹',
    '【': '︻',
    '】': '︼',
  };

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
    if (_punctuation.contains(char)) {
      return RotatedBox(
        quarterTurns: -2,
        child: Text(char, style: style),
      );
    } else if (_rotateList.keys.contains(char)) {
      return Text(_rotateList[char], style: style);
    } else {
      return Text(char, style: style);
    }
  }

  void _calcRecognizedWidth(BuildContext context, BoxConstraints constraints) {
    if (horizontalRecognizedListener != null) {
      final provider = context.read<PlaybackProvider>();
      final lineChar = constraints.maxHeight ~/ (provider.fontSize * 1.2);
      final recognizedLine = (recognizedText.length / lineChar).ceil();
      horizontalRecognizedListener(
        recognizedLine * provider.fontHeight * provider.fontSize +
            provider.fontSize,
      );
    }
  }
}
