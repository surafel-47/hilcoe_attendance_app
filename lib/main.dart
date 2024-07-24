// ignore_for_file: prefer_const_constructors, unused_import

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hilcoe_attendance_app/Models/StudentModels.dart';
import 'package:hilcoe_attendance_app/Models/TeacherModels.dart';
import 'package:hilcoe_attendance_app/Utilies/my_utils.dart';
import 'package:hilcoe_attendance_app/Widgets/TeacherScreen/Components/generate_report_screen.dart';
import 'package:hilcoe_attendance_app/Widgets/OnBoardingAndLoginScreen/create_account_screen.dart';
import 'package:hilcoe_attendance_app/Widgets/OnBoardingAndLoginScreen/login_screen.dart';
import 'package:hilcoe_attendance_app/Widgets/StudentScreen/student_home.dart';
import 'package:hilcoe_attendance_app/Widgets/StudentScreen/student_notifications.dart';
import 'package:hilcoe_attendance_app/Widgets/StudentScreen/student_report_screen.dart';
import 'package:hilcoe_attendance_app/Widgets/TeacherScreen/Components/notify_students_screen.dart';
import 'package:hilcoe_attendance_app/Widgets/TeacherScreen/Components/results_attendance.dart';
import 'package:hilcoe_attendance_app/Widgets/TeacherScreen/teacher_screen.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/no_conn_error_screen.dart';
import 'package:provider/provider.dart';
import 'Services/student_api_repo.dart';
import 'Services/teacher_api_repo.dart';
import 'Widgets/CommonWidgets/custom_wigets.dart';
import 'Widgets/OnBoardingAndLoginScreen/Components/enter_id_overlay_screen.dart';
import 'Widgets/OnBoardingAndLoginScreen/onboarding_screen.dart';
import 'Widgets/StudentScreen/student_screen.dart';
import 'Widgets/CommonWidgets/generate_analytics.dart';
import 'Widgets/TeacherScreen/Components/view_attendance_detail.dart';
import 'Widgets/TeacherScreen/Components/loading_screen.dart';
import 'Widgets/TeacherScreen/Components/mark_manually.dart';
import 'Widgets/TeacherScreen/Components/take_attendance.dart';
import 'Widgets/CommonWidgets/settings.dart';
import 'package:http/http.dart' as http;

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  // Apply the custom HttpOverrides globally before the app starts
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      home: GetBaseUrlScreen(),
    ),
  );
}

class GetBaseUrlScreen extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  //   return OnBoardingScreen();
  // }

  TextEditingController baseUrlTxtCtr = TextEditingController();

  GetBaseUrlScreen() {
    baseUrlTxtCtr.text = MyUtils.baseUrl;
  }

  @override
  Widget build(BuildContext context) {
    // TeacherModel teacherModel = TeacherModel(
    //   objectId: "65d250992a80d7ace1fb19d4",
    //   teacherName: "Abraham Girma",
    //   email: "abrahamgirma@example.com",
    //   password: "mgCb7jD1",
    //   teacherId: "PZJFE",
    // );

    // StudentModel studentModel = StudentModel(
    //   objectId: "65d24d652a80d7ace1fb19c5",
    //   studentName: "Kalkidane",
    //   email: "student1@example.com",
    //   password: "password1",
    //   studentId: "WVWYSU",
    // );

    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(
    //       create: (context) => TeacherApiRepo(teacherModel: TeacherModel()),
    //     ),
    //     ChangeNotifierProvider(
    //       create: (context) => StudentApiRepo(studentModel: studentModel),
    //     ),
    //     // Add more providers if needed
    //   ],
    //   // child: MaterialApp(home: TeacherScreen()),
    //   child: MaterialApp(home: StudentScreen()),
    // );

    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                MyCustomAppBar(centerText: "Enter Server Url"),
                SizedBox(height: 20),
                MyCustomTextField(txtController: baseUrlTxtCtr, leadingIcon: Icons.link),
                SizedBox(height: 20),
                MyCustomButton(
                  btnText: "Procced",
                  btnOnTap: () {
                    MyUtils.baseUrl = baseUrlTxtCtr.text;

                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return OnBoardingScreen();
                      },
                    ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
