// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable, use_key_in_widget_constructors, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hilcoe_attendance_app/Models/CommonModels.dart';
import 'package:hilcoe_attendance_app/Services/student_api_repo.dart';
import 'package:hilcoe_attendance_app/Utilies/my_utils.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/custom_wigets.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/screen_colors.dart';
import 'package:hilcoe_attendance_app/Widgets/OnBoardingAndLoginScreen/onboarding_screen.dart';
import 'package:provider/provider.dart';

import '../../Services/teacher_api_repo.dart';
import 'snack_bar_msg.dart';

class SettingsScreen extends StatelessWidget {
  double scrW = 0, scrH = 0;

  @override
  Widget build(BuildContext context) {
    final studentApiRepo = Provider.of<StudentApiRepo>(context, listen: false);
    final teacherApiRepo = Provider.of<TeacherApiRepo>(context, listen: false);

    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                height: scrH * 0.1,
                child: Text(
                  "Settings",
                  style: GoogleFonts.kumbhSans(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: scrH * 0.034,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "Account",
                style: GoogleFonts.kumbhSans(color: MyColors.btnBgColor, fontSize: scrH * 0.02),
              ),
              Container(
                height: scrH * 0.06,
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 5),
                  onTap: () {},
                  leading: Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: scrW * 0.043),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Color.fromARGB(255, 208, 198, 198),
                  ),
                ),
              ),
              Divider(color: Color.fromARGB(255, 239, 234, 234)),
              Container(
                height: scrH * 0.06,
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 5),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ChangePassWordCard();
                      },
                    ));
                  },
                  leading: Text(
                    "Password",
                    style: TextStyle(fontSize: scrW * 0.043),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Color.fromARGB(255, 208, 198, 198),
                  ),
                ),
              ),
              Divider(color: Color.fromARGB(255, 239, 234, 234)),
              SizedBox(height: 5),
              Text(
                "Preferences",
                style: GoogleFonts.kumbhSans(color: MyColors.btnBgColor, fontSize: scrH * 0.02),
              ),
              Container(
                height: scrH * 0.06,
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 5),
                  onTap: () {},
                  leading: Text(
                    "Notifications",
                    style: TextStyle(fontSize: scrW * 0.043),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Color.fromARGB(255, 208, 198, 198),
                  ),
                ),
              ),
              Divider(color: Color.fromARGB(255, 239, 234, 234)),
              Text(
                "Support",
                style: GoogleFonts.kumbhSans(color: MyColors.btnBgColor, fontSize: scrH * 0.02),
              ),
              SizedBox(height: 5),
              SizedBox(
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 5),
                  onTap: () {},
                  leading: Text(
                    "Request Admin Support",
                    style: TextStyle(fontSize: scrW * 0.043),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Color.fromARGB(255, 208, 198, 198),
                  ),
                ),
              ),
              Divider(color: Color.fromARGB(255, 239, 234, 234)),
              SizedBox(
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 5),
                  onTap: () {
                    MyCustomSnackBar(
                            context: context,
                            message: "You Can Contact Admin at +251-XX-XX-XXXX \nHiLCoE Reception Office No 404",
                            duration: Duration(seconds: 4),
                            leadingIcon: Icons.info_outline_rounded,
                            bgColor: MyColors.snackBarSuccesColor)
                        .show();
                  },
                  leading: Text(
                    "Contact System Admin",
                    style: TextStyle(fontSize: scrW * 0.043),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Color.fromARGB(255, 208, 198, 198),
                  ),
                ),
              ),
              Divider(color: Color.fromARGB(255, 239, 234, 234)),
              SizedBox(height: 5),
              Text(
                "Others",
                style: GoogleFonts.kumbhSans(color: MyColors.btnBgColor, fontSize: scrH * 0.02),
              ),
              SizedBox(
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 5),
                  onTap: () {},
                  leading: Text(
                    "Terms of Service & Privacy",
                    style: TextStyle(fontSize: scrW * 0.043),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Color.fromARGB(255, 208, 198, 198),
                  ),
                ),
              ),
              Divider(color: Color.fromARGB(255, 239, 234, 234)),
              SizedBox(
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 5),
                  onTap: () async {
                    await MyUtils.clearLoggedInUserData();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => OnBoardingScreen()),
                      (route) => false,
                    );
                  },
                  leading: Text(
                    "Sign Out",
                    style: TextStyle(fontSize: scrW * 0.043),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Color.fromARGB(255, 208, 198, 198),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePassWordCard extends StatelessWidget {
  TextEditingController newPasswordTxrCtr = TextEditingController();
  TextEditingController confirmNewPasswordTxrCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final teacherApiRepo = Provider.of<TeacherApiRepo>(context, listen: false);
    final studentApiRepo = Provider.of<StudentApiRepo>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              MyCustomAppBar(
                  barHeight: 100,
                  centerText: "Change Password",
                  leadingIcon: Icons.arrow_left,
                  leadingIconOnTap: () {
                    Navigator.pop(context);
                  }),
              Column(
                children: [
                  MyCustomTextField(
                    txtController: TextEditingController(),
                    hintText: teacherApiRepo.teacherModel.password == "" ? studentApiRepo.studentModel.password : teacherApiRepo.teacherModel.password,
                    txtBoxEnabled: false,
                    leadingIcon: Icons.lock_person,
                  ),
                  SizedBox(height: 10),
                  MyCustomPasswordField(
                    txtController: newPasswordTxrCtr,
                    hintText: "New Password",
                  ),
                  SizedBox(height: 10),
                  MyCustomPasswordField(
                    txtController: confirmNewPasswordTxrCtr,
                    hintText: "Confirm Password",
                  ),
                  SizedBox(height: 10),
                  MyCustomButton(
                    btnText: "Change",
                    btnOnTap: () async {
                      try {
                        FocusScope.of(context).unfocus();

                        MyUtils.validatePassword(newPasswordTxrCtr.text.trim());

                        if (newPasswordTxrCtr.text.trim() != confirmNewPasswordTxrCtr.text.trim()) {
                          throw CustomException("Confirmation Password Don't Match");
                        }

                        if (teacherApiRepo.teacherModel.password != "") {
                          await teacherApiRepo.setPassword(newPasswordTxrCtr.text.trim());
                          //logout
                          await MyUtils.clearLoggedInUserData();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => OnBoardingScreen()),
                            (route) => false,
                          );
                          return;
                        } else if (studentApiRepo.studentModel.password != "") {
                          await studentApiRepo.setPassword(newPasswordTxrCtr.text.trim());
                          //logout
                          await MyUtils.clearLoggedInUserData();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => OnBoardingScreen()),
                            (route) => false,
                          );
                          return;
                        }
                      } catch (err) {
                        MyCustomSnackBar(context: context, message: err.toString(), leadingIcon: Icons.error).show();
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
