import 'package:flutter/material.dart';
import 'package:presc/config/playback_text_style.dart';

class HorizontalText extends StatelessWidget {
  HorizontalText({
    Key key,
    @required this.recognizedText,
    @required this.unrecognizedText,
  }) : super(key: key);

  final String recognizedText;
  final String unrecognizedText;

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
    final length = recognizedText
        .replaceAll('\n', '')
        .length;
    final split = (recognizedText + unrecognizedText).split("\n");

    List<Widget> list = [];
    int totalSplitLength = 0;
    for (int i = 0; i < split.length; i++) {
      list.add(_textWrap(split[i].runes, length - totalSplitLength));
      totalSplitLength += split[i].length;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: list,
    );
  }

  Widget _textWrap(Runes runes, int distance) {
    int i = 0;
    List<Widget> list = [];
    for (var rune in runes) {
      list.add(
        Row(
          children: [
            _text(String.fromCharCode(rune), recognized: i - distance < 0),
            const SizedBox(width: 16),
          ],
        ),
      );
      i++;
    }

    return Wrap(
      textDirection: TextDirection.rtl,
      direction: Axis.vertical,
      children: list,
    );
  }

  Widget _text(String char, {bool recognized = false}) {
    final style = recognized
        ? PlaybackTextStyle.recognized(PlaybackAxis.horizontal)
        : PlaybackTextStyle.unrecognized(PlaybackAxis.horizontal);
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
}
