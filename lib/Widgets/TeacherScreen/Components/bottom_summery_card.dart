// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Services/teacher_api_repo.dart';

class BottomSummryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final teacherApiRepo = Provider.of<TeacherApiRepo>(context, listen: true);

    return Container(
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
                "${teacherApiRepo.persentStudentList.length} Students",
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
                "${teacherApiRepo.absentStudentList.length} Students",
                style: TextStyle(color: Color.fromARGB(255, 171, 153, 153), fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
