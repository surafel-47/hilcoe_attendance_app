// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/generate_analytics.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/custom_wigets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Models/CommonModels.dart';
import '../../../Services/teacher_api_repo.dart';
import '../../../Utilies/my_utils.dart';
import '../../CommonWidgets/screen_colors.dart';
import 'bottom_summery_card.dart';
import 'results_attendance.dart';

class ViewAttendanceDetail extends StatelessWidget {
  double scrW = 0, scrH = 0;
  Map<String, dynamic> jsonData;
  ViewAttendanceDetail({required this.jsonData});
  @override
  Widget build(BuildContext context) {
    // final teacherApiRepo = Provider.of<TeacherApiRepo>(context, listen: false);

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
                  leadingIcon: Icons.arrow_left,
                  leadingIconOnTap: () {
                    Navigator.pop(context);
                  },
                  centerText: "Report",
                  barHeight: scrH * 0.15,
                ),
                SizedBox(
                  height: scrH * 0.03,
                  child: Row(
                    children: [
                      Text(
                        "Date: ",
                        style: GoogleFonts.kumbhSans(
                          color: Color.fromARGB(255, 69, 65, 65),
                        ),
                      ),
                      Text(
                        DateFormat('hh:mm a MM/dd/yyyy').format(DateTime.parse(jsonData['attendanceModel']['date'])),
                        style: GoogleFonts.kumbhSans(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${jsonData['attendanceModel']['course_id']} Section ${jsonData['attendanceModel']['section']}",
                    style: GoogleFonts.kumbhSans(
                      fontWeight: FontWeight.bold,
                      fontSize: scrH * 0.02,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: scrH * 0.55,
                  decoration: BoxDecoration(border: Border.all(color: MyColors.fadedBorder), borderRadius: BorderRadius.circular(15)),
                  child: ListView.builder(
                    itemCount: jsonData['studentsList'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('assets/personPlaceHolder.png'),
                          foregroundImage: NetworkImage('${MyUtils.baseUrl}/profileImages/${jsonData['studentsList'][index]['profile_url']}'),
                        ),
                        title: Text(
                          jsonData['studentsList'][index]['student_name'],
                          // teacherApiRepo.absentStudentList[index].studentName,
                          style: GoogleFonts.kumbhSans(
                            color: Color.fromARGB(255, 125, 120, 120),
                            fontSize: scrH * 0.016,
                          ),
                        ),
                        subtitle: Text(
                          jsonData['studentsList'][index]['studentPresent'] == true ? "Present" : "Absent",
                          style: GoogleFonts.kumbhSans(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: scrH * 0.02,
                          ),
                        ),
                        trailing: Icon(
                          Icons.circle,
                          color: jsonData['studentsList'][index]['studentPresent'] == true ? Colors.lightBlue : Colors.black54,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                    height: scrH * 0.1,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color.fromARGB(255, 220, 215, 215),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Present",
                                style: TextStyle(color: Color.fromARGB(255, 171, 153, 153), fontSize: 15),
                              ),
                              Text(
                                jsonData['totalPresentStudent'].toString(),
                                // "${teacherApiRepo.persentStudentList.length} Students",
                                style: TextStyle(color: Color.fromARGB(255, 171, 153, 153), fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Absent",
                                style: TextStyle(color: Color.fromARGB(255, 171, 153, 153), fontSize: 15),
                              ),
                              Text(
                                jsonData['totalAbsentStudent'].toString(),
                                // "${teacherApiRepo.absentStudentList.length} Students",
                                style: TextStyle(color: Color.fromARGB(255, 171, 153, 153), fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
