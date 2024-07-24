// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable, use_key_in_widget_constructors, use_build_context_synchronously
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hilcoe_attendance_app/Models/CommonModels.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/custom_wigets.dart';
import 'package:provider/provider.dart';

import '../../../Services/teacher_api_repo.dart';
import '../../../Utilies/my_utils.dart';
import '../../CommonWidgets/screen_colors.dart';
import '../../CommonWidgets/snack_bar_msg.dart';

class NotifyStudentsScreen extends StatefulWidget {
  var jsonResponse;
  String courseId;
  NotifyStudentsScreen({required this.jsonResponse, required this.courseId});

  @override
  State<NotifyStudentsScreen> createState() => _NotifyStudentsScreenState();
}

class _NotifyStudentsScreenState extends State<NotifyStudentsScreen> {
  double scrW = 0, scrH = 0;

  @override
  Widget build(BuildContext context) {
    final teacherApiRepo = Provider.of<TeacherApiRepo>(context, listen: true);

    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              MyCustomAppBar(
                barHeight: scrH * 0.15,
                leadingIcon: Icons.arrow_left,
                leadingIconOnTap: () {
                  Navigator.pop(context);
                },
                centerText: "Low Attendance",
              ),
              Container(
                height: scrH * 0.05,
                alignment: Alignment.centerLeft,
                child: Text(
                  "Student List",
                  style: GoogleFonts.kumbhSans(
                    fontSize: scrH * 0.019,
                    color: Colors.blue,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                height: scrH * 0.63,
                child: ListView.builder(
                  itemCount: widget.jsonResponse.length,
                  itemBuilder: (context, index) {
                    return LowStudentAttendaceCard(
                      name: widget.jsonResponse[index]['student_name'],
                      profileUrl: widget.jsonResponse[index]['profile_url'],
                      percentage: widget.jsonResponse[index]['attendance_percentage'],
                    );
                  },
                ),
              ),
              SizedBox(
                height: scrH * 0.08,
                child: MyCustomButton(
                  txtColor: Colors.white,
                  backgroundColor: MyColors.btnBgColor,
                  btnText: "Notify All",
                  btnOnTap: () async {
                    try {
                      await teacherApiRepo.notifyStudentsWithWarning(widget.courseId);
                      Navigator.pop(context);
                    } catch (err) {
                      MyCustomSnackBar(context: context, message: err.toString(), leadingIcon: Icons.error_outline).show();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LowStudentAttendaceCard extends StatelessWidget {
  double scrH = 0;
  String name, profileUrl, percentage;
  LowStudentAttendaceCard({required this.name, required this.percentage, required this.profileUrl});
  @override
  Widget build(BuildContext context) {
    scrH = MediaQuery.of(context).size.height;
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          foregroundImage: NetworkImage('${MyUtils.baseUrl}/profileImages/$profileUrl'),
          backgroundImage: AssetImage('assets/personPlaceHolder.png'),
        ),
        title: Text(
          name,
          style: GoogleFonts.kumbhSans(fontWeight: FontWeight.w600),
        ),
        subtitle: Text("Overall attendance: $percentage%"),
        // trailing: SizedBox(
        //   height: scrH * 0.06,
        //   child: ElevatedButton(
        //     onPressed: () {
        //     },
        //     style: ElevatedButton.styleFrom(
        //       elevation: 0,
        //       foregroundColor: Color.fromARGB(255, 48, 87, 184),
        //       backgroundColor: Color.fromARGB(255, 227, 232, 252),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(15),
        //       ),
        //     ),
        //     child: Text(
        //       'Notify them',
        //       style: TextStyle(
        //         fontSize: scrH * 0.02,
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
