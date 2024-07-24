// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/screen_colors.dart';

class MyCustomSnackBar {
  final BuildContext context;
  final String message;
  final IconData? leadingIcon;
  final Duration duration;
  final Color bgColor;

  MyCustomSnackBar({
    required this.context,
    required this.message,
    this.leadingIcon,
    this.bgColor = MyColors.snackBarFailColor,
    this.duration = const Duration(seconds: 2),
  });

  void show() {
    final snackBar = SnackBar(
      backgroundColor: bgColor,
      content: Row(
        children: [
          if (leadingIcon != null) Icon(leadingIcon),
          SizedBox(width: leadingIcon != null ? 8 : 0),
          Expanded(child: Text(message)),
        ],
      ),
      duration: duration,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
