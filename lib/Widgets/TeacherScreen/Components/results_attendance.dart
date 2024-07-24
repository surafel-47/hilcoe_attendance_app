// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable, use_key_in_widget_constructors, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:hilcoe_attendance_app/Widgets/TeacherScreen/Components/mark_manually.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/custom_wigets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import '../../../Models/CommonModels.dart';
import '../../../Services/teacher_api_repo.dart';
import '../../../Utilies/my_utils.dart';
import '../../CommonWidgets/screen_colors.dart';
import '../../CommonWidgets/snack_bar_msg.dart';
import 'bottom_summery_card.dart';

class ResultsAttendance extends StatelessWidget {
  double scrW = 0, scrH = 0;
  @override
  Widget build(BuildContext context) {
    final teacherApiRepo = Provider.of<TeacherApiRepo>(context, listen: false);

    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.height;
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          Navigator.pop(context);
          Navigator.pop(context);

          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return MyConfirmOverLay(
          //       closeBtnOnTap: () {
          //         Navigator.pop(context);
          //       },
          //       msg: "Do you want to exit \nbefore saving ",
          //       firstOptBtnTxt: "Yes",
          //       firstOptOnTap: () {
          //         //Dont save data?
          //         //CircularProgressIndicator() until undo current save things then exec this
          //         Navigator.pop(context); //pop overlay screen
          //         Navigator.pop(context);
          //       },
          //       secondOptBtnTxt: "No",
          //       secondOptOnTap: () {
          //         Navigator.pop(context);
          //       },
          //     );
          //   },
          // );
        },
        child: Scaffold(
          body: Container(
            color: MyColors.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  MyCustomAppBar(
                    barHeight: scrH * 0.1,
                    leadingIcon: Icons.home_outlined,
                    leadingIconOnTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);

                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return MyConfirmOverLay(
                      //       closeBtnOnTap: () {
                      //         Navigator.pop(context);
                      //       },
                      //       msg: "Do you want to exit \nbefore saving ",
                      //       firstOptBtnTxt: "Yes",
                      //       firstOptOnTap: () {
                      //         //Dont save data?
                      //         //CircularProgressIndicator() until undo current save things then exec this
                      //         Navigator.pop(context); //pop overlay screen
                      //         Navigator.pop(context); //pop results screen
                      //         // Navigator.pop(context); //pop take attendace screen
                      //         //You'll end up at Home Page
                      //       },
                      //       secondOptBtnTxt: "No",
                      //       secondOptOnTap: () {
                      //         Navigator.pop(context);
                      //       },
                      //     );
                      //   },
                      // );
                    },
                    centerText: "Results",
                    trailingIcon: Icons.auto_graph_rounded,
                    trailingIconOnTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => MarkManuallyScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: scrH * 0.03,
                    child: Row(
                      children: [
                        Text(
                          "Time Completed: ",
                          style: GoogleFonts.kumbhSans(
                            color: Color.fromARGB(255, 69, 65, 65),
                          ),
                        ),
                        Text(
                          MyUtils.getCurrentTime(),
                          style: GoogleFonts.kumbhSans(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        InkWell(
                            child: Text(
                          "Statistics",
                          style: GoogleFonts.kumbhSans(
                            color: Color.fromARGB(255, 144, 137, 237),
                            fontSize: scrW * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                      ],
                    ),
                  ),
                  SizedBox(height: scrH * 0.02),
                  SizedBox(
                    height: scrH * 0.32,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: scrH * 0.01, // Adjust the gap between rows
                        crossAxisSpacing: scrH * 0.01, // Adjust the gap between columns
                        childAspectRatio: 4.5 / 3, // Aspect ratio of 4:3
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return AddSessionPhotoCardUpload(url: "${MyUtils.baseUrl}/AttendanceImages/${teacherApiRepo.recentAttendanceModel.imageUrl[index]}");
                      },
                      itemCount: teacherApiRepo.recentAttendanceModel.imageUrl.length,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => MarkManuallyScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Full List",
                          style: GoogleFonts.kumbhSans(
                            fontWeight: FontWeight.bold,
                            fontSize: scrH * 0.02,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_outlined, size: scrH * 0.025),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: scrH * 0.2,
                    child: ParitalAttendance(),
                  ),
                  SizedBox(height: scrH * 0.01),
                  SizedBox(height: scrH * 0.1, child: BottomSummryCard()),
                  SizedBox(height: scrH * 0.01),
                  MyCustomButton(
                    btnText: "Save",
                    btnHeight: scrH * 0.07,
                    btnOnTap: () async {
                      try {
                        await teacherApiRepo.saveAttendance();
                        teacherApiRepo.clearAttendanceData();
                        MyCustomSnackBar(
                            context: context,
                            message: "Attendance Saved Successfully!",
                            duration: Duration(seconds: 4),
                            leadingIcon: Icons.check,
                            bgColor: MyColors.snackBarSuccesColor);

                        await Future.delayed(Duration(seconds: 1));

                        Navigator.pop(context); //pop results  screen
                        Navigator.pop(context); //pop take attendace screen
                      } catch (err) {
                        MyCustomSnackBar(context: context, message: err.toString(), leadingIcon: Icons.error).show();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddSessionPhotoCardUpload extends StatelessWidget {
  String url;
  AddSessionPhotoCardUpload({required this.url});
  double scrW = 0, scrH = 0;
  @override
  Widget build(BuildContext context) {
    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.height;

    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(15),
      strokeWidth: 1,
      dashPattern: [5, 5], // Adjust these values for the pattern
      color: MyColors.fadedBorder,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoView(
                imageProvider: NetworkImage(url),
                loadingBuilder: (context, event) => Center(
                  child: CircularProgressIndicator(), // Show loading indicator
                ),
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(7),
          child: Image.network(url, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class ParitalAttendance extends StatelessWidget {
  double scrW = 0, scrH = 0;
  @override
  Widget build(BuildContext context) {
    final teacherApiRepo = Provider.of<TeacherApiRepo>(context, listen: true);

    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(border: Border.all(color: MyColors.fadedBorder), borderRadius: BorderRadius.circular(15)),
      child: ListView.builder(
        itemCount: teacherApiRepo.absentStudentList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/personPlaceHolder.png'),
              foregroundImage: NetworkImage('${MyUtils.baseUrl}/profileImages/${teacherApiRepo.absentStudentList[index].profileUrl}'),
            ),
            title: Text(
              teacherApiRepo.absentStudentList[index].studentName,
              style: GoogleFonts.kumbhSans(
                color: Color.fromARGB(255, 125, 120, 120),
                fontSize: scrH * 0.016,
              ),
            ),
            subtitle: Text(
              'Absent',
              style: GoogleFonts.kumbhSans(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: scrH * 0.02,
              ),
            ),
            trailing: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: '0',
                    style: GoogleFonts.kumbhSans(fontWeight: FontWeight.bold, fontSize: scrH * 0.022),
                  ),
                  TextSpan(
                    text: '/1',
                    style: GoogleFonts.kumbhSans(
                      color: const Color.fromARGB(255, 111, 107, 107),
                      fontSize: scrH * 0.017,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
