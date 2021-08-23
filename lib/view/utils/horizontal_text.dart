import 'package:flutter/material.dart';

class HorizontalText extends StatelessWidget {
  HorizontalText(this.text);

  final String text;

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
    final split = text.split("\n");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        for (var s in split) _textWrap(s.runes),
      ],
    );
  }

  Widget _textWrap(Runes runes) {
    return Wrap(
      textDirection: TextDirection.rtl,
      direction: Axis.vertical,
      children: [
        for (var rune in runes)
          Row(
            children: [
              _text(String.fromCharCode(rune)),
              SizedBox(width: 16),
            ],
          )
      ],
    );
  }

  Widget _text(String char) {
    final style = TextStyle(
      color: Colors.white,
      height: 1.3,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    );
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
