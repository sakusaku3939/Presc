import 'package:flutter/material.dart';

class PopupMenu extends StatelessWidget {
  PopupMenu(
    this.menuItem, {
    this.offset = const Offset(0, 0),
    this.icon,
    this.size,
    required this.onSelected,
  });

  final List<PopupMenuEntry<String>> menuItem;
  final Offset offset;
  final Icon? icon;
  final double? size;
  final Function(String value) onSelected;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipOval(
        child: Material(
          type: MaterialType.transparency,
          child: PopupMenuButton<String>(
            surfaceTintColor: Colors.transparent,
            offset: offset,
            icon: icon,
            iconSize: size,
            itemBuilder: (context) => menuItem,
            onSelected: onSelected,
          ),
        ),
      ),
    );
  }
}
