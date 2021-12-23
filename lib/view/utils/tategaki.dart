import 'package:flutter/material.dart';
import 'package:presc/config/vertical_rotated.dart';

class Tategaki extends StatelessWidget {
  Tategaki(
    this.text, {
    Key key,
    this.style,
    this.children,
  }) : super(key: key);

  final String text;
  final TextStyle style;
  final List<TextSpan> children;

  @override
  Widget build(BuildContext context) {
    final mergeStyle = DefaultTextStyle.of(context).style.merge(style);
    // final mergeDefault = (s) => DefaultTextStyle.of(context).style.merge(s);
    // List<TextStyle> styleList = [];

    // final List<TextSpan> textLenList =
    //     children != null ? children.map((e) => e.text.length).toList() : [];
    // final List<TextStyle> styleList = children != null
    //     ? children
    //         .map((e) => DefaultTextStyle.of(context).style.merge(e.style))
    //         .toList()
    //     : [DefaultTextStyle.of(context).style.merge(style)];

    // if (children != null) {
    //   for (TextSpan child in children) {
    //     styleList.add(child.style);
    //   }
    //   children.map((e) => e.text.length);
    // }

    final text =
        children != null ? children.map((e) => e.text).join() : this.text;
    final childrenStyle = getChildrenStyle(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final squareCountList = calcSquareCount(
          text,
          childrenStyle.values.first,
          Size(constraints.maxWidth, constraints.maxHeight),
        );
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: CustomPaint(
            size: Size(
              squareCountList.length *
                  childrenStyle.values.first.fontSize *
                  childrenStyle.values.first.height,
              constraints.maxHeight,
            ),
            painter: _TategakiPainter(
              text,
              childrenStyle,
              squareCountList,
            ),
          ),
        );
      },
    );
  }

  Map<int, TextStyle> getChildrenStyle(BuildContext context) {
    final mergeDefault = (s) => DefaultTextStyle.of(context).style.merge(s);
    Map<int, TextStyle> childrenStyle = {};
    int i = 0;

    if (children != null) {
      for (TextSpan child in children) {
        if (child.text.length != 0) {
          childrenStyle[i] = mergeDefault(child.style);
          i += child.text.length;
        }
      }
    } else {
      childrenStyle[text.length] = mergeDefault(style);
    }

    print(childrenStyle);
    return childrenStyle;
  }

  List<int> calcSquareCount(String text, TextStyle style, Size size) {
    final columnSquareCount = (size.height / (style.fontSize * 1.2)).ceil();
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
  _TategakiPainter(this.text, this.childrenStyle, this.squareCountList);

  final String text;
  final Map<int, TextStyle> childrenStyle;
  final List<int> squareCountList;

  int charIndex = 0;
  TextStyle currentStyle;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    currentStyle = childrenStyle.values.first;

    for (int x = 0; x < squareCountList.length; x++) {
      drawTextLine(canvas, size, x);
    }

    canvas.restore();
  }

  void drawTextLine(Canvas canvas, Size size, int x) {
    final runes = text.replaceAll('\n', '').runes;
    final fontSize = currentStyle.fontSize;
    final charWidth = fontSize * currentStyle.height;

    for (int y = 0; y < squareCountList[x]; y++) {
      if (runes.length <= charIndex) return;
      if (childrenStyle[charIndex] != null) {
        currentStyle = childrenStyle[charIndex];
      }

      String char = String.fromCharCode(runes.elementAt(charIndex));
      if (VerticalRotated.map[char] != null) {
        char = VerticalRotated.map[char] ?? "";
      }

      TextSpan span = TextSpan(
        style: currentStyle.merge(TextStyle(height: 1.6)),
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
          (y * fontSize * 1.2).toDouble(),
        ),
      );
      charIndex++;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
