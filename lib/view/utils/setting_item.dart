import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  SettingItem({
    this.title,
    this.subtitle,
    this.enabled = true,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Colors.white,
      child: ListTile(
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        contentPadding: const EdgeInsets.only(left: 32),
        enabled: enabled,
        onTap: onTap,
      ),
    );
  }
}
