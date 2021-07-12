import 'package:flutter/material.dart';

class RippleIconButton extends StatelessWidget {
  RippleIconButton(this.icon, {this.size = 24, this.onPressed});

  final IconData icon;
  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipOval(
        child: Material(
          type: MaterialType.transparency,
          child: IconButton(
            icon: Icon(
              icon,
              color: Colors.grey[700],
              size: size,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
