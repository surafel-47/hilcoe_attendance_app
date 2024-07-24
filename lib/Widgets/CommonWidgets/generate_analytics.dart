// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable, use_key_in_widget_constructors, use_build_context_synchronously
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hilcoe_attendance_app/Models/TeacherModels.dart';
import 'package:hilcoe_attendance_app/Widgets/TeacherScreen/Components/notify_students_screen.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/custom_wigets.dart';
import 'package:provider/provider.dart';

import '../../Services/teacher_api_repo.dart';
import 'snack_bar_msg.dart';

class GenerateAnalyticsScreen extends StatelessWidget {
  final bool showNotifyStudentsBtn;
  final String courseId;
  final Map<String, dynamic> jsonResult;
  GenerateAnalyticsScreen({
    this.showNotifyStudentsBtn = false,
    required this.courseId,
    required this.jsonResult,
  });
  double scrW = 0, scrH = 0;

  @override
  Widget build(BuildContext context) {
    TeacherApiRepo teacherApiRepo = TeacherApiRepo(teacherModel: TeacherModel());

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
                centerText: "Analytics",
                trailingIcon: showNotifyStudentsBtn == true ? Icons.auto_graph_rounded : Icons.abc,
                // trailingIcon: Icons.access_alarm,
                leadingIconOnTap: () {
                  Navigator.pop(context);
                },
                trailingIconOnTap: () async {
                  try {
                    var jsonResponse = await teacherApiRepo.getStudentsWithWarning(courseId);
                    print(jsonResponse);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return NotifyStudentsScreen(jsonResponse: jsonResponse, courseId: courseId);
                        },
                      ),
                    );
                  } catch (err) {
                    print(err);
                    MyCustomSnackBar(context: context, message: err.toString(), leadingIcon: Icons.error_outline).show();
                  }
                },
              ),
              SizedBox(height: scrH * 0.30, child: MyBarChart(jsonResult: jsonResult)),
              SizedBox(height: scrH * 0.05),
              SizedBox(height: scrH * 0.4, child: MyPieChart(jsonResult: jsonResult)),
            ],
          ),
        ),
      ),
    );
  }
}

class MyBarChart extends StatelessWidget {
  final Map<String, dynamic> jsonResult;
  MyBarChart({required this.jsonResult});
  double scrW = 0;
  @override
  Widget build(BuildContext context) {
    scrW = MediaQuery.of(context).size.width;
    return BarChart(
      BarChartData(
        borderData: FlBorderData(
          border: Border(
            top: BorderSide.none,
            right: BorderSide.none,
            left: BorderSide(width: 1),
            bottom: BorderSide(width: 1),
          ),
        ),
        minY: 0,
        maxY: 100,
        groupsSpace: 10,
        titlesData: FlTitlesData(
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                return Text(
                  jsonResult['result']['monthlyReport'][index]['monthName'].toString(),
                  style: TextStyle(
                    fontSize: scrW * 0.04,
                  ),
                );
              },
            ),
          ),
        ),
        // add bars
        barGroups: [
          BarChartGroupData(
            x: 4,
            barRods: [
              BarChartRodData(
                borderRadius: BorderRadius.zero,
                toY: jsonResult['result']['monthlyReport'][4]['monthValue'].toDouble() ?? 00,
                width: scrW * 0.1,
                color: Color.fromARGB(255, 29, 29, 59),
              ),
            ],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                borderRadius: BorderRadius.zero,
                toY: jsonResult['result']['monthlyReport'][3]['monthValue'].toDouble() ?? 00,
                width: scrW * 0.1,
                color: Color.fromARGB(255, 115, 115, 179),
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                borderRadius: BorderRadius.zero,
                toY: jsonResult['result']['monthlyReport'][2]['monthValue'].toDouble() ?? 00,
                width: scrW * 0.1,
                color: Color.fromARGB(255, 29, 29, 59),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                borderRadius: BorderRadius.zero,
                toY: jsonResult['result']['monthlyReport'][1]['monthValue'].toDouble() ?? 00,
                width: scrW * 0.1,
                color: Color.fromARGB(255, 115, 115, 179),
              ),
            ],
          ),
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                borderRadius: BorderRadius.zero,
                toY: jsonResult['result']['monthlyReport'][0]['monthValue'].toDouble() ?? 00,
                width: scrW * 0.1,
                color: Color.fromARGB(255, 29, 29, 59),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyPieChart extends StatelessWidget {
  final Map<String, dynamic> jsonResult;
  double myChartValue = 00;
  MyPieChart({required this.jsonResult}) {
    myChartValue = jsonResult['result']['totalAverageAttendance'].toDouble();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: LayoutBuilder(
        builder: (context, constraint) {
          double cardH = constraint.maxHeight;
          double cardW = constraint.maxWidth;

          return Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: cardH * 0.1,
                child: Text(
                  "Overall Percentage:\t ${jsonResult['result']['totalAverageAttendance'] ?? "00"}%",
                  style: GoogleFonts.kumbhSans(fontSize: cardH * 0.06, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: cardH * 0.9,
                child: SizedBox(
                  width: cardW * 0.6,
                  height: cardW * 0.6,
                  child: Stack(
                    children: [
                      PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(value: 100 - myChartValue, color: Color.fromARGB(255, 151, 188, 232), showTitle: false),
                            PieChartSectionData(value: myChartValue, color: Color.fromARGB(255, 128, 167, 214), showTitle: false),
                          ],
                        ),
                      ),
                      Center(
                        child: Text(
                          "${jsonResult['result']['totalAverageAttendance'] ?? "00"}%",
                          style: GoogleFonts.kumbhSans(fontSize: cardH * 0.07, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
