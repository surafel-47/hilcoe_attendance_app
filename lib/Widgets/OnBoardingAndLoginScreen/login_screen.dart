// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hilcoe_attendance_app/Models/CommonModels.dart';
import 'package:hilcoe_attendance_app/Models/StudentModels.dart';
import 'package:hilcoe_attendance_app/Models/TeacherModels.dart';
import 'package:hilcoe_attendance_app/Services/student_api_repo.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/settings.dart';
import 'package:hilcoe_attendance_app/Widgets/OnBoardingAndLoginScreen/Components/enter_id_overlay_screen.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/custom_wigets.dart';
import 'package:hilcoe_attendance_app/Widgets/StudentScreen/student_screen.dart';
import 'package:hilcoe_attendance_app/Widgets/TeacherScreen/teacher_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services/login_signup_api_repo.dart';
import '../../Services/teacher_api_repo.dart';
import '../CommonWidgets/screen_colors.dart';
import '../CommonWidgets/snack_bar_msg.dart';

class LoginInScreen extends StatefulWidget {
  LoginInScreen({super.key});

  @override
  State<LoginInScreen> createState() => _LoginInScreenState();
}

class _LoginInScreenState extends State<LoginInScreen> {
  bool _rememberMe = false;
  double scrH = 0, scrW = 0;

  TextEditingController emailTxtCtr = TextEditingController();
  TextEditingController passwordTxtCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    scrH = MediaQuery.of(context).size.height;
    scrW = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Container(
          color: MyColors.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  MyCustomAppBar(
                    barHeight: scrH * 0.25,
                    leadingIcon: Icons.arrow_left_sharp,
                    leadingIconOnTap: () {
                      Navigator.pop(context);
                    },
                    centerText: "",
                  ),
                  SizedBox(
                    height: scrH * 0.08,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Glad To Have You back!",
                          style: GoogleFonts.kumbhSans(fontSize: scrW * 0.065, color: Colors.black, fontWeight: FontWeight.bold),
                        )),
                  ),
                  MyCustomTextField(
                    txtController: emailTxtCtr,
                    hintText: "Email Address",
                    leadingIcon: Icons.email_outlined,
                  ),
                  SizedBox(height: 20),
                  MyCustomPasswordField(txtController: passwordTxtCtr),
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                            ),
                            Text("Remember me"),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {},
                            child: Text("Forgot Password?"),
                          ),
                        )
                      ],
                    ),
                  ),
                  MyCustomButton(
                    btnText: "Sign In",
                    btnOnTap: () async {
                      try {
                        FocusScope.of(context).unfocus();

                        if (emailTxtCtr.text.isEmpty) {
                          throw CustomException('Email Empty');
                        }
                        if (passwordTxtCtr.text.isEmpty) {
                          throw CustomException('Password Empty');
                        }

                        //start the log in proccess
                        var loginRepo = LoginAndSignUpApiServices();

                        var jsonResult = await loginRepo.loginUser(emailTxtCtr.text.trim(), passwordTxtCtr.text.trim());

                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        if (jsonResult['userType'] == 'student') {
                          StudentModel studentModel = StudentModel.fromJson(jsonResult['person']);
                          studentModel.printStudentDetails();

                          if (_rememberMe) {
                            //Setting the Users Id and Type
                            await prefs.setString('userType', 'student');
                            await prefs.setString('objectId', studentModel.objectId);
                          }

                          //Naviagate to Students screen with a provider from here
                          //change to Push Replacement here
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider(
                                      create: (context) => StudentApiRepo(studentModel: studentModel),
                                    ),
                                    ChangeNotifierProvider(
                                      create: (context) => TeacherApiRepo(teacherModel: TeacherModel()),
                                    ),
                                    // Add more providers if needed
                                  ],
                                  child: MaterialApp(
                                    debugShowCheckedModeBanner: false,
                                    home: StudentScreen(),
                                  ),
                                );
                              },
                            ),
                            (route) => false,
                          );
                          MyCustomSnackBar(
                                  context: context, message: "Logged In Student", duration: Duration(seconds: 4), leadingIcon: Icons.check, bgColor: MyColors.snackBarSuccesColor)
                              .show();
                        } else if (jsonResult['userType'] == 'teacher') {
                          TeacherModel teacherModel = TeacherModel.fromJson(jsonResult['person']);
                          teacherModel.printTeacherDetails();

                          if (_rememberMe) {
                            //Setting the Users Id and Type
                            await prefs.setString('userType', 'teacher');
                            await prefs.setString('objectId', teacherModel.objectId);
                          }

                          //Naviagate to Teacher screen with a provider from here
                          //change to Push Replacement here
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider(
                                      create: (context) => TeacherApiRepo(teacherModel: teacherModel),
                                    ),
                                    ChangeNotifierProvider(
                                      create: (context) => StudentApiRepo(studentModel: StudentModel()),
                                    ),
                                  ],
                                  child: MaterialApp(
                                    debugShowCheckedModeBanner: false,
                                    home: TeacherScreen(),
                                  ),
                                );
                              },
                            ),
                            (route) => false,
                          );
                          MyCustomSnackBar(
                                  context: context,
                                  message: "Logged In Instructor",
                                  duration: Duration(seconds: 4),
                                  leadingIcon: Icons.check,
                                  bgColor: MyColors.snackBarSuccesColor)
                              .show();
                        }
                      } catch (err) {
                        MyCustomSnackBar(context: context, message: err.toString(), leadingIcon: Icons.error).show();
                      }

                      //To Teacher or Admin or Student

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return MyConfirmOverLay(
                      //         msg: "This is Demoo",
                      //         closeBtnOnTap: () {
                      //           Navigator.pop(context);
                      //         },
                      //         firstOptBtnTxt: "Go TO Teacher Screen",
                      //         firstOptOnTap: () {
                      //           Navigator.pushReplacement(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) {
                      //                 return TeacherScreen();
                      //               },
                      //             ),
                      //           );
                      //         },
                      //         secondOptBtnTxt: "Go TO Student Screen",
                      //         secondOptOnTap: () {
                      //           Navigator.pushReplacement(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) {
                      //                 return StudentScreen();
                      //               },
                      //             ),
                      //           );
                      //         },
                      //       );
                      //     },
                      //   ),
                      // );
                    },
                  ),
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "New Here?",
                          style: TextStyle(color: MyColors.fadedBorder),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                opaque: false, // set to false
                                pageBuilder: (_, __, ___) => EnterIdOverLayScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Create Account",
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
      ),
    );
  }
}
