import 'package:flutter/material.dart';
import 'package:presc/config/color_config.dart';

class RippleIconButton extends StatelessWidget {
  RippleIconButton(
    this.icon, {
    this.size = 24,
    this.color = ColorConfig.iconColor,
    this.disabledColor,
    this.onPressed,
  });

  final IconData icon;
  final double size;
  final Color color;
  final Color? disabledColor;
  final VoidCallback? onPressed;

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
              size: size,
            ),
            color: color,
            disabledColor: disabledColor,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
