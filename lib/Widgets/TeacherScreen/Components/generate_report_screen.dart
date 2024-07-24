// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable, use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/generate_analytics.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/custom_wigets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Models/CommonModels.dart';
import '../../../Services/teacher_api_repo.dart';
import '../../CommonWidgets/snack_bar_msg.dart';
import 'view_attendance_detail.dart';
import '../../CommonWidgets/screen_colors.dart';

class GenrateReportScreen extends StatefulWidget {
  @override
  State<GenrateReportScreen> createState() => _GenrateReportScreenState();
}

class _GenrateReportScreenState extends State<GenrateReportScreen> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController useStudentIdtxtCtr = TextEditingController();
  TextEditingController useStudentIdCourseId = TextEditingController();

  TextEditingController useDateCourseIdtxtCtr = TextEditingController();
  TextEditingController useDateSectionCtr = TextEditingController();

  TextEditingController useCourseIdtxtCtr = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  double scrW = 0, scrH = 0;

  @override
  Widget build(BuildContext context) {
    final teacherApiRepo = Provider.of<TeacherApiRepo>(context, listen: false);

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
                ExpansionTile(
                  title: Text(
                    "Use Student ID",
                    style: GoogleFonts.kumbhSans(fontWeight: FontWeight.bold, fontSize: scrH * 0.03),
                  ),
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Color.fromARGB(255, 223, 218, 218))),
                      child: Column(
                        children: [
                          MyCustomTextField(
                            hintText: "Student ID",
                            leadingIcon: Icons.numbers,
                            txtController: useStudentIdtxtCtr,
                          ),
                          SizedBox(height: 10),
                          MyCustomTextField(
                            hintText: 'Course Code',
                            leadingIcon: Icons.edit_square,
                            txtController: useStudentIdCourseId,
                          ),
                          SizedBox(height: 15),
                          MyCustomButton(
                              btnText: "Generate Report",
                              btnOnTap: () async {
                                FocusScope.of(context).unfocus();

                                try {
                                  var jsonResult = await teacherApiRepo.getAnalyticsUseStudentId(useStudentIdtxtCtr.text.trim(), useStudentIdCourseId.text.trim());
                                  // print(jsonResult.toString());

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GenerateAnalyticsScreen(
                                        showNotifyStudentsBtn: true,
                                        courseId: useStudentIdCourseId.text.trim(),
                                        jsonResult: jsonResult,
                                      ),
                                    ),
                                  );
                                } catch (err) {
                                  // print(err);
                                  MyCustomSnackBar(context: context, message: err.toString(), leadingIcon: Icons.error_outline).show();
                                }
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    "Use Date",
                    style: GoogleFonts.kumbhSans(fontWeight: FontWeight.bold, fontSize: scrH * 0.03),
                  ),
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: MyColors.fadedBorder)),
                      child: Column(
                        children: [
                          MyCustomTextField(
                            hintText: 'Course Code',
                            leadingIcon: Icons.edit_square,
                            txtController: useDateCourseIdtxtCtr,
                          ),
                          SizedBox(height: 15),
                          MyCustomTextField(
                            hintText: 'Section',
                            leadingIcon: Icons.edit_square,
                            txtController: useDateSectionCtr,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            decoration: InputDecoration(
                              labelText: 'Select Date',
                              suffixIcon: Icon(Icons.access_time),
                            ),
                            controller: TextEditingController(
                              text: DateFormat('yyyy-MM-dd').format(_selectedDate),
                            ),
                          ),
                          SizedBox(height: 15),
                          MyCustomButton(
                            btnText: "Generate Report",
                            btnOnTap: () async {
                              FocusScope.of(context).unfocus();

                              try {
                                var jsonResult = await teacherApiRepo.getAnalyticsUseDate(useDateCourseIdtxtCtr.text.trim(), useDateSectionCtr.text.trim(), _selectedDate);
                                // print(jsonResult.toString());

                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return ViewAttendanceDetail(
                                      jsonData: jsonResult,
                                    );
                                  },
                                ));
                              } catch (err) {
                                print(err);
                                MyCustomSnackBar(context: context, message: err.toString(), leadingIcon: Icons.error_outline).show();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    "Use Course Code",
                    style: GoogleFonts.kumbhSans(fontWeight: FontWeight.bold, fontSize: scrH * 0.03),
                  ),
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Color.fromARGB(255, 223, 218, 218))),
                      child: Column(
                        children: [
                          MyCustomTextField(
                            hintText: 'Course Code',
                            leadingIcon: Icons.edit_square,
                            txtController: useCourseIdtxtCtr,
                          ),
                          SizedBox(height: 15),
                          MyCustomButton(
                            btnText: "Generate Report",
                            btnOnTap: () async {
                              FocusScope.of(context).unfocus();
                              try {
                                var jsonResult = await teacherApiRepo.getAnalyticsUseCourseId(useCourseIdtxtCtr.text.trim());
                                // print(jsonResult.toString());

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GenerateAnalyticsScreen(
                                      showNotifyStudentsBtn: true,
                                      courseId: useCourseIdtxtCtr.text.trim(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
