// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/custom_wigets.dart';

import 'screen_colors.dart';

class NoConnectionErrorScreen extends StatelessWidget {
  double scrW = 0, scrH = 0;

  @override
  Widget build(BuildContext context) {
    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(height: scrH * 0.3),
              Container(
                height: scrH * 0.3,
                child: Image.asset('assets/noConn.png'),
              ),
              Center(
                child: Text(
                  "No Connection",
                  style: GoogleFonts.kumbhSans(fontWeight: FontWeight.bold, fontSize: scrW * 0.07),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "We can’t detect an internet connection. Don’t fret, just try again.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.kumbhSans(fontSize: scrW * 0.04, color: MyColors.fadedBorder),
                ),
              ),
              Spacer(),
              MyCustomButton(
                  btnText: "Try Again",
                  btnOnTap: () {
                    Navigator.pop(context);
                  }),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
