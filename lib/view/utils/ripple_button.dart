import 'package:flutter/material.dart';
import 'package:presc/config/custom_color.dart';

class RippleIconButton extends StatelessWidget {
  RippleIconButton(
    this.icon, {
    this.size = 24,
    this.color = CustomColor.iconColor,
    this.onPressed,
  });

  final IconData icon;
  final double size;
  final Color color;
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
              color: color,
              size: size,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
