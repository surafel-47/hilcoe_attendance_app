// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, must_be_immutable, non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hilcoe_attendance_app/Models/StudentModels.dart';
import 'package:hilcoe_attendance_app/Services/student_api_repo.dart';
import 'package:hilcoe_attendance_app/Utilies/my_utils.dart';
import 'package:provider/provider.dart';

import '../../Models/CommonModels.dart';
import '../CommonWidgets/custom_wigets.dart';
import '../CommonWidgets/screen_colors.dart';
import '../CommonWidgets/snack_bar_msg.dart';

class StudentNotificationScreen extends StatelessWidget {
  double scrW = 0, scrH = 0;
  bool isThereNotifcation = true;
  @override
  Widget build(BuildContext context) {
    final studentApiRepo = Provider.of<StudentApiRepo>(context, listen: false);

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
                centerText: "Notifications",
                leadingIconOnTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: scrH * 0.65,
                child: FutureBuilder(
                  future: studentApiRepo.getNotifications(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      //  Text('Data: ${snapshot.data}');
                      return NotificationCard(jsonData: snapshot.data);
                    }
                  },
                ),
              ),
              // SizedBox(height: scrH * 0.65, child: isThereNotifcation ? NotificationCard() : NoNoificationcard()),
              SizedBox(height: scrH * 0.05),
              MyCustomButton(
                btnText: "Back Home",
                btnOnTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatefulWidget {
  var jsonData;
  NotificationCard({required this.jsonData});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  double scrW = 0, scrH = 0;
  List<CourseNotifcationModel> courseNotificationList = [];

  @override
  void initState() {
    super.initState();
    // Access jsonData and set notificationsCount
    courseNotificationList = (widget.jsonData as List<dynamic>).map((json) => CourseNotifcationModel.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final studentApiRepo = Provider.of<StudentApiRepo>(context, listen: false);
    // print(widget.jsonData);
    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color.fromARGB(255, 240, 238, 238)),
      ),
      child: courseNotificationList.isEmpty
          ? NoNoificationcard()
          : ListView.separated(
              itemCount: courseNotificationList.length,
              separatorBuilder: (context, index) {
                return Divider(
                  color: const Color.fromARGB(255, 217, 216, 216),
                );
              },
              itemBuilder: (context, index) {
                return SizedBox(
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Low Attendace",
                          style: GoogleFonts.kumbhSans(color: MyColors.btnBgColor),
                        ),
                        Text(
                          MyUtils.getTimeFromDataTime(courseNotificationList[index].date),
                          style: GoogleFonts.kumbhSans(color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: '${courseNotificationList[index].courseId} ${courseNotificationList[index].courseName}', // First word
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Bold style for the first word
                                  ),
                                ),
                                TextSpan(
                                  text: ' you have low attendance', // Rest of the text
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                          ),
                          onPressed: () async {
                            try {
                              await studentApiRepo.clearNotification(courseNotificationList[index].courseId, courseNotificationList[index].date);
                            } catch (err) {
                              MyCustomSnackBar(context: context, message: err.toString(), leadingIcon: Icons.error_outline).show();
                              return;
                            }
                            setState(() {
                              courseNotificationList.removeAt(index);
                              print('sss--${courseNotificationList.length}');
                            });
                          },
                        ),
                      ],
                    )
                  ]),
                );
              },
            ),
    );
  }
}

class NoNoificationcard extends StatelessWidget {
  double scrW = 0, scrH = 0;

  @override
  Widget build(BuildContext context) {
    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(
          height: scrH * 0.3,
          child: Image.asset('assets/NoNotifications.png'),
        ),
        Center(
          child: Text(
            "No notifications yet",
            style: GoogleFonts.kumbhSans(fontWeight: FontWeight.bold, fontSize: scrW * 0.07),
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Text(
            "When you have notifications, they’ll appear here.",
            textAlign: TextAlign.center,
            style: GoogleFonts.kumbhSans(fontSize: scrW * 0.04, color: MyColors.fadedBorder),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
