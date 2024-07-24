// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hilcoe_attendance_app/Models/TeacherModels.dart';
import 'package:hilcoe_attendance_app/Services/teacher_api_repo.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/generate_analytics.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/custom_wigets.dart';
import 'package:provider/provider.dart';

import '../../Services/student_api_repo.dart';
import '../CommonWidgets/screen_colors.dart';
import '../CommonWidgets/snack_bar_msg.dart';

class StudentReportScreen extends StatelessWidget {
  double scrW = 0, scrH = 0;
  TextEditingController useStudentIdCourseId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final studentApiRepo = Provider.of<StudentApiRepo>(context, listen: false);
    final teacherApiRepo = TeacherApiRepo(teacherModel: TeacherModel());

    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                MyCustomAppBar(
                  centerText: "Report",
                  barHeight: scrH * 0.15,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Color.fromARGB(255, 223, 218, 218),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Student ID: ${studentApiRepo.studentModel.studentId}",
                          style: GoogleFonts.kumbhSans(fontSize: scrH * 0.02),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: scrH * 0.08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Color.fromARGB(255, 59, 57, 57),
                          ),
                        ),
                        child: MyCustomTextField(
                          leadingIcon: Icons.numbers,
                          txtController: useStudentIdCourseId,
                          hintText: "Course Code",
                        ),
                      ),
                      SizedBox(height: 15),
                      MyCustomButton(
                        btnText: "Generate Report",
                        btnOnTap: () async {
                          try {
                            FocusScope.of(context).unfocus();
                            var jsonResult = await teacherApiRepo.getAnalyticsUseStudentId(studentApiRepo.studentModel.studentId, useStudentIdCourseId.text.trim());
                            // print(jsonResult.toString());

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GenerateAnalyticsScreen(
                                  courseId: useStudentIdCourseId.text.trim(),
                                  jsonResult: jsonResult,
                                ),
                              ),
                            );
                          } catch (err) {
                            // print(err);
                            MyCustomSnackBar(context: context, message: err.toString(), leadingIcon: Icons.error_outline).show();
                          }
                        },
                      ),
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
