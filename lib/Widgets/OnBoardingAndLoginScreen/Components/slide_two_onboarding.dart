// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SlideTwoOnBoarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraint) {
          double cardW = constraint.maxWidth;
          double cardH = constraint.maxHeight;
          return Column(
            children: [
              Container(
                height: cardH * 0.6,
                child: Stack(
                  children: [
                    Align(
                      child: SizedBox(
                        width: cardH * 0.45,
                        height: cardH * 0.45,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment(0, -1),
                              end: Alignment(0, 1),
                              colors: <Color>[Color(0xff75a4fe), Color(0x008962ee)],
                              stops: <double>[0, 0.703],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      child: SizedBox(
                        width: 220,
                        height: 220,
                        child: Image.asset("assets/8.png"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Organized record of your students attendance statistics.",
                    style: GoogleFonts.kumbhSans(color: Colors.white, fontSize: cardW * 0.065, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(height: cardH * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Track all students of your class, no matter how big or small they are. Have a detailed record of all time attendance records taken, all on your device.",
                    style: GoogleFonts.kumbhSans(color: Color.fromARGB(255, 226, 216, 251), fontSize: cardH * 0.028, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
