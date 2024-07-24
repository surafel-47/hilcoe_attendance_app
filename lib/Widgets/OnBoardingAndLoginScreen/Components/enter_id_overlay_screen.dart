// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable, use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hilcoe_attendance_app/Models/CommonModels.dart';
import 'package:hilcoe_attendance_app/Models/TeacherModels.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/snack_bar_msg.dart';
import 'package:hilcoe_attendance_app/Widgets/OnBoardingAndLoginScreen/create_account_screen.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/custom_wigets.dart';

import '../../../Models/StudentModels.dart';
import '../../../Services/login_signup_api_repo.dart';
import '../../CommonWidgets/screen_colors.dart';

class EnterIdOverLayScreen extends StatelessWidget {
  double scrW = 0, scrH = 0;
  TextEditingController idTxtCtr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    scrH = MediaQuery.of(context).size.height;
    scrW = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(37, 0, 0, 0),
        body: Container(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment(0, -0.5),
                child: Container(
                  height: scrH * 0.37,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color.fromARGB(255, 255, 255, 255),
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
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: scrH * 0.015),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 239, 237, 237),
                            ),
                            height: scrH * 0.015,
                            width: scrW * 0.15,
                          ),
                        ),
                        Container(
                          height: scrH * 0.12,
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: MyColors.fadedBorder, width: 1),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  "Enter the unique ID \nnumber given by your \nschool administrator",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.kumbhSans(color: Colors.black, fontWeight: FontWeight.bold, fontSize: scrH * 0.023),
                                ),
                              ),
                            ],
                          ),
                        ),
                        MyCustomTextField(
                          fieldHeight: scrH * 0.08,
                          leadingIcon: Icons.numbers,
                          hintText: "ID Number",
                          txtController: idTxtCtr,
                        ),
                        SizedBox(height: scrH * 0.02),
                        MyCustomButton(
                          btnHeight: scrH * 0.07,
                          btnText: "Procced",
                          btnOnTap: () async {
                            try {
                              if (idTxtCtr.text.isEmpty) {
                                throw CustomException("ID is Empty");
                              }
                              var loginAndSignUpApiServices = LoginAndSignUpApiServices();
                              var jsonResult = await loginAndSignUpApiServices.signUpValidateIdNumber(idTxtCtr.text.trim());
                              if (jsonResult['userType'] == "student") {
                                StudentModel studentModel = StudentModel.fromJson(jsonResult['person']);
                                studentModel.printStudentDetails();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateAccountScreen(
                                      personModel: studentModel,
                                    ),
                                  ),
                                );
                              } else if (jsonResult['userType'] == "teacher") {
                                TeacherModel teacherModel = TeacherModel.fromJson(jsonResult['person']);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateAccountScreen(
                                      personModel: teacherModel,
                                    ),
                                  ),
                                );
                              }
                            } catch (err) {
                              MyCustomSnackBar(context: context, message: err.toString(), leadingIcon: Icons.error_outline).show();
                            }
                          },
                        ),
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
