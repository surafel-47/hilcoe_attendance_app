// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/custom_wigets.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/screen_colors.dart';

class MyConfirmOverLay extends StatelessWidget {
  final VoidCallback firstOptOnTap;
  final VoidCallback secondOptOnTap;
  final VoidCallback closeBtnOnTap;
  final String firstOptBtnTxt;
  final String secondOptBtnTxt;

  final String msg;

  final VoidCallback thirdOptTap;
  final String thirdOptBtnTxt;

  static void _defaultCallback() {
    print("Default Tapped");
  }

  MyConfirmOverLay({
    this.firstOptOnTap = _defaultCallback,
    this.secondOptOnTap = _defaultCallback,
    this.thirdOptTap = _defaultCallback,
    this.closeBtnOnTap = _defaultCallback,
    this.msg = "",
    this.firstOptBtnTxt = "",
    this.secondOptBtnTxt = "",
    this.thirdOptBtnTxt = "",
  });

  double scrH = 0, scrW = 0;

  @override
  Widget build(BuildContext context) {
    scrH = MediaQuery.of(context).size.height;
    scrW = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Material(
        color: Color.fromARGB(37, 0, 0, 0),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: scrH * 0.38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: MyColors.backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 1,
                        color: Color.fromARGB(52, 0, 0, 0),
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: scrH * 0.015),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: MyColors.backgroundColor,
                            ),
                            height: scrH * 0.015,
                            width: scrW * 0.15,
                          ),
                        ),
                        SizedBox(
                          height: scrH * 0.1,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: MyColors.fadedBorder, width: 1),
                                  ),
                                  child: IconButton(icon: Icon(Icons.close), onPressed: closeBtnOnTap),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  msg,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.kumbhSans(fontWeight: FontWeight.bold, fontSize: scrH * 0.023),
                                ),
                              ),
                            ],
                          ),
                        ),
                        MyCustomButton(
                          btnHeight: scrH * 0.07,
                          btnText: firstOptBtnTxt,
                          btnOnTap: firstOptOnTap,
                        ),
                        SizedBox(height: scrH * 0.02),
                        MyCustomButton(
                          btnHeight: scrH * 0.07,
                          btnText: secondOptBtnTxt,
                          btnOnTap: secondOptOnTap,
                          backgroundColor: MyColors.cancelBtnColor,
                        ),
                        SizedBox(height: 15),

                        if (thirdOptBtnTxt != "")
                          MyCustomButton(
                            btnHeight: scrH * 0.07,
                            btnText: thirdOptBtnTxt,
                            btnOnTap: thirdOptTap,
                            backgroundColor: MyColors.cancelBtnColor,
                          ),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: InkWell(
                        //     onTap: () {
                        //       print("Retake Attendace!");
                        //     },
                        //     child: Text(
                        //       "Retake Attendance",
                        //       style: TextStyle(color: MyColors.fadedBorder),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
