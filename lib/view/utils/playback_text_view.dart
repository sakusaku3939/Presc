import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';

class PlaybackTextView extends StatelessWidget {
  PlaybackTextView(
    this.text, {
    this.height,
    this.scroll = true,
    this.gradientFraction = 0.2,
  });

  final String text;
  final double height;
  final bool scroll;
  final double gradientFraction;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(scroll ? 0 : 24);
    });
    return Container(
      height: height,
      child: FadingEdgeScrollView.fromSingleChildScrollView(
        gradientFractionOnStart: gradientFraction,
        gradientFractionOnEnd: gradientFraction,
        child: SingleChildScrollView(
          physics: (scroll)
              ? BouncingScrollPhysics()
              : NeverScrollableScrollPhysics(),
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                height: 2.2,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
