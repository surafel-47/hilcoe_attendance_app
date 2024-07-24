// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hilcoe_attendance_app/Services/teacher_api_repo.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/screen_colors.dart';
import 'package:hilcoe_attendance_app/Widgets/TeacherScreen/Components/take_attendance.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/custom_wigets.dart';
import 'package:provider/provider.dart';

import '../../Models/CommonModels.dart';
import '../../Utilies/my_utils.dart';
import '../CommonWidgets/recent_attendance_card.dart';

class TeacherHomeScreen extends StatelessWidget {
  final VoidCallback navigateToPageAnalytics;
  double scrH = 0, scrW = 0;
  TeacherHomeScreen({required this.navigateToPageAnalytics});
  @override
  Widget build(BuildContext context) {
    final teacherApiRepo = Provider.of<TeacherApiRepo>(context, listen: false);

    scrH = MediaQuery.of(context).size.height;
    scrW = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            MyCustomAppBar(
              barHeight: scrH * 0.12,
              trailingIcon: Icons.notifications_none,
              trailingIconOnTap: () {
                print("Nification Pressed");
              },
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: scrH * 0.11,
              child: Text(
                "Hi, ${MyUtils.getFirstName(teacherApiRepo.teacherModel.teacherName)}",
                style: GoogleFonts.kumbhSans(fontSize: scrW * 0.09, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: scrH * 0.08,
              alignment: Alignment.topLeft,
              child: Text(
                "Welcome Instructor",
                style: GoogleFonts.kumbhSans(
                  fontWeight: FontWeight.bold,
                  fontSize: scrW * 0.072,
                  color: MyColors.btnBgColor,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: scrH * 0.08,
              child: Text(
                "Recent Attendance",
                style: GoogleFonts.kumbhSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
            ),
            // RecentAttendanceeee
            MyCustomContainer(
              height: scrH * 0.22,
              child: FutureBuilder(
                future: teacherApiRepo.getRecentAttendance(teacherApiRepo.teacherModel.teacherId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    List<RecentAttendanceModel> recentAttendanceModelList = [];
                    List<Map<String, dynamic>> jsonData = snapshot.data!;
                    for (var recentAttendanceJson in jsonData) {
                      RecentAttendanceModel recentAttendanceModel = RecentAttendanceModel.fromJson(recentAttendanceJson);
                      recentAttendanceModelList.add(recentAttendanceModel);
                    }
                    return RecentAttendanceCard(recentAttendanceModelsList: recentAttendanceModelList, showAttendanceDetails: true);
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  return Center(
                    child: Text("You Haven't taken any \nattendances", textAlign: TextAlign.center),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: scrH * 0.08,
              child: TextButton(
                onPressed: () {
                  navigateToPageAnalytics();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Attendance Report",
                      style: GoogleFonts.kumbhSans(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: scrW * 0.052,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_outlined),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: scrH * 0.08,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => TakeAttendanceScreen(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Take Attendance",
                      style: GoogleFonts.kumbhSans(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: scrW * 0.052,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_outlined),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
