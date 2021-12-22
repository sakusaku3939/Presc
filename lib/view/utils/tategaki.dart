import 'package:flutter/material.dart';
import 'package:presc/config/vertical_rotated.dart';

class Tategaki extends StatelessWidget {
  Tategaki(
    this.text, {
    Key key,
    this.style,
  }) : super(key: key);

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final mergeStyle = DefaultTextStyle.of(context).style.merge(style);
    return LayoutBuilder(
      builder: (context, constraints) {
        final squareCountList = calcSquareCount(
          text,
          Size(constraints.maxWidth, constraints.maxHeight),
        );
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: CustomPaint(
            size: Size(
              squareCountList.length * mergeStyle.fontSize * mergeStyle.height,
              constraints.maxHeight,
            ),
            painter: _TategakiPainter(
              text,
              mergeStyle,
              squareCountList,
            ),
          ),
        );
      },
    );
  }

  List<int> calcSquareCount(String text, Size size) {
    final columnSquareCount = size.height ~/ style.fontSize;
    int i = 0;
    List<int> countList = [];

    for (int rune in text.runes) {
      final isLast = i == columnSquareCount - 1;
      final isLF = rune == '\n'.runes.first;

      if (isLF && i != 0) {
        countList.add(i);
        i = 0;
      } else if (isLast) {
        countList.add(i + 1);
        i = 0;
      } else {
        i++;
      }
    }
    countList.add(i);

    return countList;
  }
}

class _TategakiPainter extends CustomPainter {
  _TategakiPainter(this.text, this.style, this.squareCountList);

  final String text;
  final TextStyle style;
  final List<int> squareCountList;

  int charIndex = 0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    for (int x = 0; x < squareCountList.length; x++) {
      drawTextLine(canvas, size, x);
    }

    canvas.restore();
  }

  void drawTextLine(Canvas canvas, Size size, int x) {
    final runes = text.replaceAll('\n', '').runes;
    final fontSize = style.fontSize;
    final charWidth = fontSize * style.height;

    for (int y = 0; y < squareCountList[x]; y++) {
      if (runes.length <= charIndex) return;

      String char = String.fromCharCode(runes.elementAt(charIndex));
      if (VerticalRotated.map[char] != null) {
        char = VerticalRotated.map[char] ?? "";
      }

      TextSpan span = TextSpan(
        style: style.merge(TextStyle(height: 1.6)),
        text: char,
      );
      TextPainter tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
      );

      tp.layout();
      tp.paint(
        canvas,
        Offset(
          (size.width - (x + 1) * charWidth).toDouble(),
          (y * fontSize).toDouble(),
        ),
      );
      charIndex++;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
