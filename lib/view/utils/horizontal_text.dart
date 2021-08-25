import 'package:flutter/material.dart';
import 'package:presc/config/playback_text_style.dart';
import 'package:presc/viewModel/playback_provider.dart';
import 'package:provider/provider.dart';

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
    final length = recognizedText.replaceAll('\n', '').length;
    final split = (recognizedText + unrecognizedText).split("\n");

    List<Widget> list = [];
    int totalSplitLength = 0;
    for (int i = 0; i < split.length; i++) {
      list.add(_textWrap(context, split[i].runes, length - totalSplitLength));
      totalSplitLength += split[i].length;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: list,
    );
  }

  Widget _textWrap(BuildContext context, Runes runes, int distance) {
    int i = 0;
    List<Widget> list = [];
    for (var rune in runes) {
      list.add(
        Row(
          children: [
            _text(
              context,
              String.fromCharCode(rune),
              recognized: i - distance < 0,
            ),
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

  Widget _text(BuildContext context, String char, {bool recognized = false}) {
    final config = PlaybackTextStyle.of(context.read<PlaybackProvider>());
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
}
