import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  SettingItem({
    this.leading,
    required this.title,
    this.subtitle,
    this.enabled = true,
    required this.onTap,
  });

  final Widget? leading;
  final String title;
  final String? subtitle;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Colors.white,
      child: ListTile(
        leading: leading,
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        contentPadding: const EdgeInsets.only(left: 32),
        enabled: enabled,
        onTap: onTap,
      ),
    );
  }
}
