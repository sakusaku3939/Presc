import 'package:flutter/material.dart';

class RippleIconButton extends StatelessWidget {
  RippleIconButton({this.child});

  final IconButton child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
          type: MaterialType.transparency,
          child: child
      ),
    );
  }
}