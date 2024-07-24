// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/custom_wigets.dart';
import 'package:hilcoe_attendance_app/Widgets/TeacherScreen/Components/results_attendance.dart';
import 'package:lottie/lottie.dart';

import '../../CommonWidgets/confirm_overlay.dart';
import '../../CommonWidgets/screen_colors.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          Navigator.pop(context);

          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return MyConfirmOverLay(
          //       closeBtnOnTap: () {
          //         Navigator.pop(context);
          //       },
          //       msg: "Are you sure you want \nto cancel?",
          //       firstOptBtnTxt: "Yes",
          //       firstOptOnTap: () {
          //         Navigator.pop(context);
          //       },
          //       secondOptBtnTxt: "No",
          //       secondOptOnTap: () {
          //         //Dont Forget to cancel the post methodd
          //         Navigator.pop(context);
          //       },
          //     );
          //   },
          // );
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            color: MyColors.btnBgColor,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  MyCustomAppBar(
                    barHeight: 150,
                    leadingIcon: Icons.arrow_left_sharp,
                    iconColor: Colors.white,
                    leadingIconOnTap: () {
                      Navigator.pop(context);

                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return MyConfirmOverLay(
                      //       closeBtnOnTap: () {
                      //         Navigator.pop(context);
                      //       },
                      //       msg: "Are you sure you want \nto cancel?",
                      //       firstOptBtnTxt: "Yes",
                      //       firstOptOnTap: () {
                      //         //Dont Forget to cancel the post methodd
                      //         Navigator.pop(context);
                      //       },
                      //       secondOptBtnTxt: "No",
                      //       secondOptOnTap: () {
                      //         Navigator.pop(context);
                      //       },
                      //     );
                      //   },
                      // );
                    },
                  ),
                  Center(
                    child: Lottie.asset('assets/loading.json', width: 250),
                  ),
                  Center(
                    child: Text(
                      "Proccessing",
                      style: GoogleFonts.kumbhSans(
                        color: Color.fromARGB(255, 227, 222, 222),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "This Might take few seconds!",
                      style: GoogleFonts.kumbhSans(
                        color: MyColors.backgroundColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
