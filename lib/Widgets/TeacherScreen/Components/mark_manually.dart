// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../Models/CommonModels.dart';
import '../../../Services/teacher_api_repo.dart';
import '../../../Utilies/my_utils.dart';
import 'bottom_summery_card.dart';

class MarkManuallyScreen extends StatelessWidget {
  double scrH = 0, scrW = 0;

  @override
  Widget build(BuildContext context) {
    final teacherApiRepo = Provider.of<TeacherApiRepo>(context, listen: false);

    scrH = MediaQuery.of(context).size.height;
    scrW = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  height: scrH * 0.12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Color.fromARGB(255, 215, 206, 206), width: 1),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios_new),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Text(
                        "Mark Manually",
                        style: GoogleFonts.kumbhSans(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: scrH * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Color.fromARGB(255, 215, 206, 206), width: 1),
                        ),
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Absent List",
                      style: GoogleFonts.kumbhSans(
                        fontSize: scrH * 0.019,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: scrH * 0.25,
                  child: AbsentListCard(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8.0, bottom: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Present List",
                      style: GoogleFonts.kumbhSans(
                        fontSize: scrH * 0.019,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: scrH * 0.25,
                  child: PresentListCard(),
                ),
                SizedBox(height: scrH * 0.02),
                Container(
                  height: scrH * 0.1,
                  child: BottomSummryCard(),
                ),
                SizedBox(height: scrH * 0.02),
                Container(
                  height: scrH * 0.07,
                  width: scrW,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 48, 87, 184),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: scrH * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

class AbsentListCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final teacherApiRepo = Provider.of<TeacherApiRepo>(context, listen: true);
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color.fromARGB(255, 234, 230, 230))),
      child: ListView.separated(
        itemCount: teacherApiRepo.absentStudentList.length,
        separatorBuilder: (context, index) {
          return Divider(
            endIndent: 10,
            indent: 10,
            color: const Color.fromARGB(255, 231, 226, 226),
            thickness: 1,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/personPlaceHolder.png'),
                foregroundImage: NetworkImage('${MyUtils.baseUrl}/profileImages/${teacherApiRepo.absentStudentList[index].profileUrl}'),
              ), // Optional: Leading icon
              title: Text(
                teacherApiRepo.absentStudentList[index].studentName,
                style: GoogleFonts.kumbhSans(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 221, 255, 209),
                ),
                child: IconButton(
                  onPressed: () {
                    teacherApiRepo.addStudentToPresentList(teacherApiRepo.absentStudentList[index]);
                  },
                  icon: Icon(
                    Icons.check,
                    color: Color.fromARGB(255, 39, 174, 96),
                  ),
                ),
              ) // Optional: Trailing icon
              );
        },
      ),
    );
  }
}

class PresentListCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final teacherApiRepo = Provider.of<TeacherApiRepo>(context, listen: true);

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color.fromARGB(255, 234, 230, 230))),
      child: ListView.separated(
        itemCount: teacherApiRepo.persentStudentList.length,
        separatorBuilder: (context, index) {
          return Divider(
            endIndent: 10,
            indent: 10,
            color: const Color.fromARGB(255, 231, 226, 226),
            thickness: 1,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/personPlaceHolder.png'),
                foregroundImage: NetworkImage('${MyUtils.baseUrl}/profileImages/${teacherApiRepo.persentStudentList[index].profileUrl}'),
              ), // Optional: Leading icon
              title: Text(
                teacherApiRepo.persentStudentList[index].studentName,
                style: GoogleFonts.kumbhSans(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 251, 229, 229),
                ),
                child: IconButton(
                  onPressed: () {
                    teacherApiRepo.removeStudentFromPresentList(teacherApiRepo.persentStudentList[index]);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Color.fromARGB(255, 246, 81, 81),
                  ),
                ),
              ) // Optional: Trailing icon
              );
        },
      ),
    );
  }
}
