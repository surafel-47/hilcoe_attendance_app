// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hilcoe_attendance_app/Models/CommonModels.dart';
import 'package:hilcoe_attendance_app/Models/TeacherModels.dart';
import 'package:hilcoe_attendance_app/Services/student_api_repo.dart';
import 'package:hilcoe_attendance_app/Services/teacher_api_repo.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/custom_wigets.dart';
import 'package:hilcoe_attendance_app/Widgets/StudentScreen/student_notifications.dart';
import 'package:provider/provider.dart';
import '../CommonWidgets/recent_attendance_card.dart';
import '../CommonWidgets/screen_colors.dart';

class StudentHomeScreen extends StatelessWidget {
  final VoidCallback navigateToPageAnalytics;
  double scrH = 0, scrW = 0;

  StudentHomeScreen({required this.navigateToPageAnalytics});

  @override
  Widget build(BuildContext context) {
    final studentApiRepo = Provider.of<StudentApiRepo>(context, listen: false);

    // final teacherApiRepo = TeacherApiRepo(teacherModel: TeacherModel());

    scrH = MediaQuery.of(context).size.height;
    scrW = MediaQuery.of(context).size.width;

    return Container(
      color: MyColors.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            MyCustomAppBar(
              barHeight: scrH * 0.12,
              trailingIcon: Icons.notifications_active_outlined,
              trailingIconOnTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return StudentNotificationScreen();
                    },
                  ),
                );
              },
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: scrH * 0.11,
              child: Text(
                "Hi, ${studentApiRepo.studentModel.studentName}",
                style: GoogleFonts.kumbhSans(fontSize: scrW * 0.09, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: scrH * 0.08,
              alignment: Alignment.topLeft,
              child: Text(
                "Welcome to your class",
                style: GoogleFonts.kumbhSans(
                  fontWeight: FontWeight.bold,
                  fontSize: scrW * 0.072,
                  color: MyColors.btnBgColor,
                ),
              ),
            ),
            SizedBox(height: 10),
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
                future: studentApiRepo.getRecentAttendance(),
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
                    return RecentAttendanceCard(recentAttendanceModelsList: recentAttendanceModelList, showAttendanceDetails: false);
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  return Center(
                    child: Text(
                      "No Attendances for Courses You've \nEnrolled In so far",
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
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
                      " My Attendance Report",
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
