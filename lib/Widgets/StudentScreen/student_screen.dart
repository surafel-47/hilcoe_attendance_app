// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:hilcoe_attendance_app/Widgets/StudentScreen/student_home.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/settings.dart';
import '../CommonWidgets/screen_colors.dart';
import 'student_report_screen.dart';

class StudentScreen extends StatefulWidget {
  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  int selIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      StudentHomeScreen(navigateToPageAnalytics: () {
        setState(() {
          selIndex = 1;
        });
      }),
      StudentReportScreen(),
      SettingsScreen(),
    ];
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            IndexedStack(
              index: selIndex,
              children: items,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 25,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color.fromARGB(255, 235, 232, 232), Colors.white],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: MyColors.btnBgColor,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            FocusScope.of(context).unfocus();
            selIndex = value;
            setState(() {});
          },
          currentIndex: selIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_sharp),
              label: "Report",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}
