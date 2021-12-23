import 'package:flutter/material.dart';
import 'package:presc/viewModel/speech_to_text_provider.dart';
import 'package:provider/provider.dart';
import 'package:presc/config/vertical_rotated.dart';

class Tategaki extends StatelessWidget {
  Tategaki(
    this.text, {
    Key key,
    this.style,
    this.recognizeStyle,
    this.recognizeIndex = 0,
  }) : super(key: key);

  final String text;
  final TextStyle style;
  final TextStyle recognizeStyle;
  final int recognizeIndex;

  @override
  Widget build(BuildContext context) {
    final mergeStyle = DefaultTextStyle.of(context).style.merge(style);
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final charWidth = mergeStyle.fontSize * mergeStyle.height;
        _reflectVerticalRecognizeWidth(context, size, charWidth);
        final squareCountList = _calcSquareCount(text, size);

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: RepaintBoundary(
            child: CustomPaint(
              size: Size(
                squareCountList.length * charWidth,
                constraints.maxHeight,
              ),
              painter: _TategakiPainter(
                text,
                mergeStyle,
                recognizeStyle,
                recognizeIndex,
                squareCountList,
              ),
            ),
          ),
        );
      },
    );
  }

  void _reflectVerticalRecognizeWidth(
    BuildContext context,
    Size size,
    double charWidth,
  ) {
    final provider = context.read<SpeechToTextProvider>();
    final recognizeLineCount =
        _calcSquareCount(text.substring(0, recognizeIndex), size).length;
    provider.verticalRecognizeWidth = recognizeLineCount * charWidth;
  }

  List<int> _calcSquareCount(String text, Size size) {
    final columnSquareCount = size.height ~/ style.fontSize;
    int i = 0;
    List<int> countList = [];

    for (int rune in text.runes) {
      final isNextLast = i == columnSquareCount - 1;
      final isNextLF = rune == '\n'.runes.first;

      if (isNextLF && i != 0) {
        countList.add(i);
        i = 0;
      } else if (isNextLast) {
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
  _TategakiPainter(
    this.text,
    this.style,
    this.recognizeStyle,
    this.recognizeIndex,
    this.squareCountList,
  );

  final String text;
  final TextStyle style;
  final TextStyle recognizeStyle;
  final int recognizeIndex;
  final List<int> squareCountList;

  int charIndex = 0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    for (int x = 0; x < squareCountList.length; x++) {
      _drawTextLine(canvas, size, x);
    }

    canvas.restore();
  }

  void _drawTextLine(Canvas canvas, Size size, int x) {
    final runes = text.replaceAll('\n', '').runes;
    final fontSize = style.fontSize;
    final charWidth = fontSize * style.height;

    for (int y = 0; y < squareCountList[x]; y++) {
      if (runes.length <= charIndex) return;

      String char = String.fromCharCode(runes.elementAt(charIndex));
      if (VerticalRotated.map[char] != null) {
        char = VerticalRotated.map[char] ?? "";
      }

      final offsetX = (size.width - (x + 1) * charWidth).toDouble();
      final offsetY = (y * fontSize).toDouble();
      TextStyle mergeStyle;

      if (recognizeStyle != null && charIndex < recognizeIndex) {
        final paint = Paint()..color = recognizeStyle.backgroundColor;
        canvas.drawRect(
          Rect.fromLTWH(
            offsetX,
            offsetY + 8,
            fontSize,
            fontSize,
          ),
          paint,
        );
        mergeStyle = recognizeStyle.merge(
          TextStyle(backgroundColor: Colors.transparent, height: 1.6),
        );
      } else {
        mergeStyle = TextStyle(height: 1.6);
      }

      TextSpan span = TextSpan(
        style: style.merge(mergeStyle),
        text: char,
      );
      TextPainter tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
      );

      tp.layout();
      tp.paint(
        canvas,
        Offset(offsetX, offsetY),
      );
      charIndex++;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
