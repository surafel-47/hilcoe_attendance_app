// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_typing_uninitialized_variables, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hilcoe_attendance_app/Widgets/TeacherScreen/Components/view_attendance_detail.dart';
import '../../Models/CommonModels.dart';
import '../../Utilies/my_utils.dart';
import 'screen_colors.dart';

class MyCustomButton extends StatelessWidget {
  final VoidCallback btnOnTap;

  final Color backgroundColor;
  final Color txtColor;

  final double btnHeight;
  final double btnWidth;
  final String btnText;
  final double fontSize;

  const MyCustomButton({
    required this.btnOnTap,
    this.backgroundColor = MyColors.btnBgColor,
    this.txtColor = Colors.white,
    this.btnHeight = 0,
    this.btnWidth = 0,
    this.btnText = "",
    this.fontSize = 0,
  });

  @override
  Widget build(BuildContext context) {
    double scrH = MediaQuery.of(context).size.height;
    double scrW = MediaQuery.of(context).size.width;

    return Container(
      height: btnHeight == 0 ? scrH * 0.07 : btnHeight,
      width: btnWidth == 0 ? scrW : btnWidth,
      child: ElevatedButton(
        onPressed: btnOnTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: txtColor,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          btnText,
          style: TextStyle(
            fontSize: fontSize == 0 ? scrH * 0.025 : fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyCustomTextField extends StatelessWidget {
  final IconData leadingIcon;
  final Color backgroundColor;
  final Color txtColor;
  final double fieldHeight;
  final double fieldWidth;
  final String hintText;
  final double fontSize;
  final bool txtBoxEnabled;
  final TextEditingController txtController;

  MyCustomTextField({
    this.backgroundColor = MyColors.btnBgColor,
    this.txtColor = MyColors.fadedBorder,
    this.fieldHeight = 0,
    this.fieldWidth = 0,
    this.hintText = "",
    this.fontSize = 0,
    this.leadingIcon = Icons.question_mark,
    this.txtBoxEnabled = true,
    required this.txtController,
  });

  double scrW = 0, scrH = 0;

  @override
  Widget build(BuildContext context) {
    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.height;
    return Container(
      height: fieldHeight == 0 ? scrH * 0.08 : fieldHeight,
      child: TextField(
        enabled: txtBoxEnabled, //set it to the value passed for txtBoxEnabled Btn param(default true)
        controller: txtController,
        decoration: InputDecoration(
          filled: !txtBoxEnabled,
          fillColor: Color.fromARGB(255, 239, 237, 237),
          hintText: hintText,
          hintStyle: TextStyle(
            color: txtBoxEnabled ? MyColors.fadedBorder : Color.fromARGB(255, 181, 176, 176),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: MyColors.fadedBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 225, 220, 220),
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 244, 240, 240),
            ),
          ),
          prefixIcon: Icon(
            leadingIcon,
            color: MyColors.fadedBorder,
          ),
        ),
      ),
    );
  }
}

class MyCustomPasswordField extends StatefulWidget {
  final double fieldHeight;
  final double fieldWidth;
  final String hintText;
  final double fontSize;
  final TextEditingController txtController;

  MyCustomPasswordField({
    this.fieldHeight = 0,
    this.fieldWidth = 0,
    this.hintText = "Password",
    this.fontSize = 0,
    required this.txtController,
  });

  @override
  State<MyCustomPasswordField> createState() => _MyCustomPasswordFieldState();
}

class _MyCustomPasswordFieldState extends State<MyCustomPasswordField> {
  double scrW = 0, scrH = 0;
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.height;
    return Container(
      height: widget.fieldHeight == 0 ? scrH * 0.08 : widget.fieldHeight,
      child: TextField(
        controller: widget.txtController,
        obscureText: _showPassword,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: MyColors.fadedBorder),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: MyColors.fadedBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 225, 220, 220),
            ),
          ),
          prefixIcon: const Icon(
            Icons.lock_outline_rounded,
            color: MyColors.fadedBorder,
          ),
          suffixIcon: IconButton(
            icon: Icon(_showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
            onPressed: () {
              setState(
                () {
                  _showPassword = !_showPassword;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class MyCustomAppBar extends StatelessWidget {
  final VoidCallback leadingIconOnTap;
  final VoidCallback trailingIconOnTap;
  final IconData leadingIcon;
  final String centerText;
  final IconData trailingIcon;
  final double barHeight;
  final double barWidth;
  final double fontSize;
  final Color iconColor;
  static void _defaultCallback() {
    print("Default Tapped");
  }

  MyCustomAppBar({
    this.leadingIconOnTap = _defaultCallback,
    this.trailingIconOnTap = _defaultCallback,
    this.barHeight = 0,
    this.barWidth = 0,
    this.centerText = "",
    this.fontSize = 0,
    this.leadingIcon = Icons.abc,
    this.trailingIcon = Icons.abc,
    this.iconColor = Colors.transparent,
  });

  double scrW = 0, scrH = 0;

  @override
  Widget build(BuildContext context) {
    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.height;
    return Container(
      height: barHeight == 0 ? scrH * 0.1 : barHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leadingIcon == Icons.abc
              ? const SizedBox()
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: MyColors.navBarBtnBorderColor),
                  ),
                  child: IconButton(
                    icon: Icon(leadingIcon, color: iconColor == Colors.transparent ? Colors.black : iconColor),
                    onPressed: leadingIconOnTap,
                  ),
                ),
          Text(
            centerText,
            style: GoogleFonts.kumbhSans(
              color: Colors.black,
              fontSize: fontSize == 0 ? scrH * 0.034 : fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailingIcon == Icons.abc
              ? const SizedBox()
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: MyColors.fadedBorder),
                  ),
                  child: IconButton(
                    icon: Icon(trailingIcon),
                    onPressed: trailingIconOnTap,
                  ),
                ),
        ],
      ),
    );
  }
}

class MyCustomContainer extends StatelessWidget {
  final double height;
  final double width;
  final Color borderColor;
  final double paddingHor;
  final double paddingvert;
  final double borderRadius;
  final Widget child;

  MyCustomContainer({
    this.height = 100,
    this.width = double.infinity,
    this.borderRadius = 15,
    this.borderColor = MyColors.fadedBorder,
    this.paddingHor = 10,
    this.paddingvert = 0,
    this.child = const SizedBox(),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingHor, vertical: paddingvert),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: MyColors.fadedBorder,
        ),
      ),
      height: height,
      width: width,
      child: child,
    );
  }
}
