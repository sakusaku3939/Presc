import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:presc/config/color_config.dart';

class PlatformSwitch extends StatelessWidget {
  const PlatformSwitch({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
      );
    } else {
      return Switch(
        activeTrackColor: ColorConfig.mainColor,
        inactiveTrackColor: ColorConfig.mainColor.withOpacity(0.1),
        value: value,
        onChanged: onChanged,
      );
    }
  }
}
