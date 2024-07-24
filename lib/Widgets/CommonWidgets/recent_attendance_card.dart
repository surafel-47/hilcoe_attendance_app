// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/screen_colors.dart';
import 'package:http/http.dart' as http;

import '../../Models/CommonModels.dart';
import '../../Utilies/my_utils.dart';
import '../TeacherScreen/Components/view_attendance_detail.dart';
// Recent Attendace Card

class RecentAttendanceCard extends StatelessWidget {
  final List<RecentAttendanceModel> recentAttendanceModelsList;
  bool showAttendanceDetails;
  RecentAttendanceCard({
    required this.recentAttendanceModelsList,
    this.showAttendanceDetails = false,
  });

  double scrW = 0, scrH = 0;

  @override
  Widget build(BuildContext context) {
    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.height;
    return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SingleChildScrollView(
          child: Column(
            children: recentAttendanceModelsList
                .map((recentAttendanceModel) => RecentAttendanceItemWidget(
                      recentAttendanceModel: recentAttendanceModel,
                      showAttendanceDetails: showAttendanceDetails,
                    ))
                .toList(),
          ),
        ));
  }
}

class RecentAttendanceItemWidget extends StatelessWidget {
  final RecentAttendanceModel recentAttendanceModel;
  final bool showAttendanceDetails;

  const RecentAttendanceItemWidget({required this.recentAttendanceModel, required this.showAttendanceDetails});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          if (showAttendanceDetails) {
            final Map<String, String> headers = {
              'API_KEY': MyUtils.API_KEY,
            };
            final String url = '${MyUtils.baseUrl}/teacherApi/getAttendanceDetails?object_id=${recentAttendanceModel.objectId}';
            final http.Response response = await http.get(
              Uri.parse(url),
              headers: headers,
            );
            if (response.statusCode != 200) {
              throw CustomException("Error Fetching Data");
            }
            Map<String, dynamic> jsonData = json.decode(response.body);
            // print(jsonData.toString());

            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ViewAttendanceDetail(
                  jsonData: jsonData,
                );
              },
            ));
          }
        } catch (err) {
          print(err);
        }
      },
      child: SizedBox(
        height: 38,
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: showAttendanceDetails
                      ? MyColors.btnBgColor
                      : recentAttendanceModel.studentPresent
                          ? MyColors.btnBgColor
                          : const Color.fromARGB(255, 188, 42, 28)),
              child: const Center(
                child: Icon(
                  Icons.circle,
                  color: Colors.white,
                  size: 18, // Size of the dot
                ),
              ),
            ),
            const SizedBox(width: 7),
            Text(
              "${recentAttendanceModel.courseId} Sec ${recentAttendanceModel.section}",
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.kumbhSans(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Expanded(
              child: Text(
                MyUtils.getTimeFromDataTime(recentAttendanceModel.date),
                textAlign: TextAlign.right,
                style: GoogleFonts.kumbhSans(color: const Color.fromARGB(255, 132, 129, 129), fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
