import 'package:flutter/material.dart';

class PopupMenu extends StatelessWidget {
  PopupMenu(this.menuItem, {@required this.onSelected});

  final List<PopupMenuEntry<String>> menuItem;
  final Function(String value) onSelected;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipOval(
        child: Material(
          type: MaterialType.transparency,
          child: PopupMenuButton<String>(
            itemBuilder: (context) => menuItem,
            onSelected: onSelected,
          ),
        ),
      ),
    );
  }
}