// ignore_for_file: file_names

import 'dart:io';

class RecentAttendanceModel {
  String objectId;
  String courseId;
  String section;
  String date;
  bool studentPresent;
  List<String> imageUrl;

  RecentAttendanceModel({
    this.objectId = "",
    this.courseId = "",
    this.section = "",
    this.date = "",
    this.studentPresent = false,
    List<String>? imageUrl,
  }) : imageUrl = imageUrl ?? [];

  factory RecentAttendanceModel.fromJson(Map<String, dynamic> json) {
    List<String>? imageUrlList = json['attendance_imgurls'] != null ? List<String>.from(json['attendance_imgurls']) : null;

    return RecentAttendanceModel(
      objectId: json['_id'] ?? "",
      courseId: json['course_id'] ?? "",
      section: json['section'] ?? "",
      date: json['date'] ?? "",
      studentPresent: json['student_present'] ?? false,
      imageUrl: imageUrlList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': objectId,
      'course_id': courseId,
      'section': section,
      'date': date,
      'attendance_imgurls': imageUrl,
    };
  }
}

class UploadAttendanceModel {
  List<File> imageFiles;
  String section;
  String courseCode;

  UploadAttendanceModel({
    required this.imageFiles,
    required this.section,
    required this.courseCode,
  });
}

class CourseNotifcationModel {
  String courseId;
  String courseName;
  String date;

  CourseNotifcationModel({
    required this.courseId,
    required this.courseName,
    required this.date,
  });

  factory CourseNotifcationModel.fromJson(Map<String, dynamic> json) {
    return CourseNotifcationModel(
      courseId: json['course_id'],
      courseName: json['course_name'],
      date: json['date'],
    );
  }
}

class CustomException implements Exception {
  final String message;

  CustomException(this.message);

  @override
  String toString() {
    return message; // Return the custom error message
  }
}
