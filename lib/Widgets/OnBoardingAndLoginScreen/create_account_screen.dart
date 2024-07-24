// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable, avoid_unnecessary_containers, sized_box_for_whitespace, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hilcoe_attendance_app/Models/CommonModels.dart';
import 'package:hilcoe_attendance_app/Services/login_signup_api_repo.dart';
import 'package:hilcoe_attendance_app/Services/teacher_api_repo.dart';
import 'package:hilcoe_attendance_app/Utilies/my_utils.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/screen_colors.dart';
import 'package:hilcoe_attendance_app/Widgets/TeacherScreen/teacher_screen.dart';
import 'package:provider/provider.dart';
import '../../Models/StudentModels.dart';
import '../../Models/TeacherModels.dart';
import '../../Services/student_api_repo.dart';
import '../CommonWidgets/custom_wigets.dart';
import '../CommonWidgets/snack_bar_msg.dart';
import '../StudentScreen/student_screen.dart';
import 'login_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  CreateAccountScreen({required this.personModel});
  final dynamic personModel;

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _termsAccepted = false;

  String getPersonNameFromObject() {
    if (widget.personModel is StudentModel) {
      return widget.personModel.studentName;
    } else if (widget.personModel is TeacherModel) {
      return widget.personModel.teacherName;
    } else {
      return "";
    }
  }

  TextEditingController emailTxtCtr = TextEditingController();
  TextEditingController passwordTxtCtr = TextEditingController();
  TextEditingController passwordConfirmTxtCtr = TextEditingController();

  double scrH = 0, scrW = 0;

  @override
  Widget build(BuildContext context) {
    scrH = MediaQuery.of(context).size.height;
    scrW = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                MyCustomAppBar(
                  barHeight: scrH * 0.15,
                  leadingIcon: Icons.arrow_left_sharp,
                  leadingIconOnTap: () {
                    Navigator.pop(context);
                  },
                  centerText: "",
                ),
                Container(
                  height: scrH * 0.1,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Please fill in your details",
                        style: TextStyle(fontSize: scrH * 0.03, color: Colors.black, fontWeight: FontWeight.bold),
                      )),
                ),
                MyCustomTextField(
                  leadingIcon: Icons.person_2_outlined,
                  hintText: getPersonNameFromObject(),
                  txtController: TextEditingController(),
                  txtBoxEnabled: false,
                ),
                SizedBox(height: 12),
                MyCustomTextField(
                  leadingIcon: Icons.phone,
                  hintText: "Email Address",
                  txtController: emailTxtCtr,
                ),
                SizedBox(height: 12),
                MyCustomPasswordField(
                  hintText: "Password",
                  txtController: passwordTxtCtr,
                ),
                SizedBox(height: 12),
                MyCustomPasswordField(
                  hintText: "Confirm Password",
                  txtController: passwordConfirmTxtCtr,
                ),
                SizedBox(height: 12),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(
                            () {
                              _termsAccepted = value!;
                            },
                          );
                        },
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: "I accept all ",
                            style: GoogleFonts.kumbhSans(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Terms of Service',
                                style: GoogleFonts.kumbhSans(
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.btnBgColor,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // print('Clicked on Terms');
                                  },
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: GoogleFonts.kumbhSans(
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.btnBgColor,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // print('Clicked on Privacy');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                MyCustomButton(
                  btnHeight: scrH * 0.07,
                  btnText: "Create Account",
                  btnOnTap: () async {
                    try {
                      FocusScope.of(context).unfocus();

                      MyUtils.validateEmail(emailTxtCtr.text);

                      MyUtils.validatePassword(passwordTxtCtr.text);

                      if (passwordTxtCtr.text.trim() != passwordConfirmTxtCtr.text.trim()) {
                        throw CustomException("Password Doesn't Match ");
                      }

                      if (_termsAccepted == false) {
                        throw CustomException("Please Accept Our Terms of Service");
                      }

                      //IF Valid, then Continue to Account Creation Request
                      LoginAndSignUpApiServices loginAndSignUpApiServices = LoginAndSignUpApiServices();
                      if (widget.personModel is StudentModel) {
                        String personId = widget.personModel.studentId;
                        var jsonResult = await loginAndSignUpApiServices.signUp('student', personId, emailTxtCtr.text.trim(), passwordTxtCtr.text.trim());
                        MyCustomSnackBar(
                                context: context,
                                message: "Student Account Successfully Created",
                                leadingIcon: Icons.check_circle_outline_outlined,
                                bgColor: MyColors.snackBarSuccesColor)
                            .show();

                        // StudentModel studentModel = StudentModel.fromJson(jsonResult['person']);
                        //Naviagate to Students screen with a provider from here
                        //change to Push Replacement here
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginInScreen();
                            },
                          ),
                          (route) => false,
                        );
                      } else if (widget.personModel is TeacherModel) {
                        String personId = widget.personModel.teacherId;
                        var jsonResult = await loginAndSignUpApiServices.signUp('teacher', personId, emailTxtCtr.text, passwordTxtCtr.text);
                        MyCustomSnackBar(
                                context: context,
                                message: "Teacher Account Successfully Created",
                                leadingIcon: Icons.check_circle_outline_outlined,
                                bgColor: MyColors.snackBarSuccesColor)
                            .show();

                        // TeacherModel teacherModel = TeacherModel.fromJson(jsonResult['person']);
                        //Naviagate to Teacher screen with a provider from here
                        //change to Push Replacement here
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginInScreen();
                            },
                          ),
                          (route) => false,
                        );
                      }
                    } catch (err) {
                      MyCustomSnackBar(context: context, message: err.toString(), leadingIcon: Icons.error_outline).show();
                    }
                  },
                ),
                SizedBox(height: 12),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Have an Account?",
                        style: TextStyle(color: MyColors.fadedBorder),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginInScreen()),
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.btnBgColor),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
