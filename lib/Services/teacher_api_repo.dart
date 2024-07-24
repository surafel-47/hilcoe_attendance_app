import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hilcoe_attendance_app/Models/StudentModels.dart';
import 'package:hilcoe_attendance_app/Models/TeacherModels.dart';
import 'package:http/http.dart' as http;

import '../Models/CommonModels.dart';
import '../Utilies/my_utils.dart';

class TeacherApiRepo extends ChangeNotifier {
  TeacherApiRepo({required this.teacherModel});

  TeacherModel teacherModel;

  List<StudentModel> persentStudentList = [];
  List<StudentModel> absentStudentList = [];
  RecentAttendanceModel recentAttendanceModel = RecentAttendanceModel();

  void clearAttendanceData() {
    persentStudentList.clear();
    absentStudentList.clear();
    recentAttendanceModel = RecentAttendanceModel();
    notifyListeners();
  }

  void setAbsentStudentList(absentStudentListJson) {
    absentStudentList.clear();
    absentStudentListJson.forEach((element) {
      StudentModel studentModel = StudentModel.fromJson(element as Map<String, dynamic>);
      absentStudentList.add(studentModel);
    });
    notifyListeners();
  }

  void setPresentStudentList(persentStudentListJson) {
    persentStudentList.clear();
    persentStudentListJson.forEach((element) {
      StudentModel studentModel = StudentModel.fromJson(element as Map<String, dynamic>);
      persentStudentList.add(studentModel);
    });
    notifyListeners();
  }

  void addStudentToPresentList(StudentModel studentModel) {
    absentStudentList.remove(studentModel);
    persentStudentList.add(studentModel);
    notifyListeners();
  }

  void removeStudentFromPresentList(StudentModel studentModel) {
    persentStudentList.remove(studentModel);
    absentStudentList.add(studentModel);
    notifyListeners();
  }

  // addImageToImageUpload

  Future<List<Map<String, dynamic>>> getRecentAttendance(String teacherId) async {
    final Map<String, String> headers = {
      'API_KEY': MyUtils.API_KEY,
      'object_id': teacherModel.objectId,
    };

    final String url = '${MyUtils.baseUrl}/teacherApi/getRecentAttendance?teacher_id=$teacherId';
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.cast<Map<String, dynamic>>();
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      throw CustomException(data['msg']);
    }
  }

  Future<Map<String, dynamic>> setPassword(String newPassWord) async {
    final Map<String, String> headers = {
      'API_KEY': MyUtils.API_KEY,
      'object_id': teacherModel.objectId,
    };

    final String url = '${MyUtils.baseUrl}/teacherApi/setNewPassword?new_password=$newPassWord';
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      return jsonData;
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      throw CustomException(data['msg']);
    }
  }

  Future<Map<String, dynamic>> isCourseIdValid(String courseId) async {
    final Map<String, String> headers = {
      'API_KEY': MyUtils.API_KEY,
      'object_id': teacherModel.objectId,
    };

    final String url = '${MyUtils.baseUrl}/teacherApi/isCourseIdValid?course_id=$courseId';
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      return jsonData;
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      throw CustomException(data['msg']);
    }
  }

  Future<Map<String, dynamic>> uploadAttendanceImages(String courseId, String section, List<File> images) async {
    final String url = '${MyUtils.baseUrl}/teacherApi/uploadAttendanceImages?course_id=$courseId&section=$section';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers
    request.headers.addAll({
      'API_KEY': MyUtils.API_KEY,
      'object_id': teacherModel.objectId,
      'Content-Type': 'application/json',
    });

    // Add image files
    for (var i = 0; i < images.length; i++) {
      var stream = http.ByteStream(images[i].openRead());
      var length = await images[i].length();
      var filename = images[i].path.split('/').last; // Get the original filename with extension
      var multipartFile = http.MultipartFile('images', stream, length, filename: filename);
      request.files.add(multipartFile);
    }

    // Send the request
    var response = await request.send();

    // Parse response
    if (response.statusCode == 200) {
      var jsonData = await response.stream.bytesToString();
      return json.decode(jsonData);
    } else {
      var jsonData = await response.stream.bytesToString();
      var data = json.decode(jsonData);
      throw CustomException(data['msg']);
    }
  }

  Future<Map<String, dynamic>> saveAttendance() async {
    final Map<String, String> headers = {
      'API_KEY': MyUtils.API_KEY,
      'object_id': teacherModel.objectId,
      'Content-Type': 'application/json',
    };

    final String url = '${MyUtils.baseUrl}/teacherApi/SaveAttenadance';

    // print(recentAttendanceModel.toJson());
    // print(json.encode(persentStudentList.map((student) => student.toJson()).toList()));
    // print(json.encode(absentStudentList.map((student) => student.toJson()).toList()));

    // Prepare the request body
    Map<String, dynamic> requestBody = {
      'recentAttendance': json.encode(recentAttendanceModel.toJson()),
      'presentStudents': json.encode(persentStudentList.map((student) => student.toJson()).toList()),
      'absentStudents': json.encode(absentStudentList.map((student) => student.toJson()).toList()),
    };

    // Send the POST request with the request body
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    // Parse response
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return jsonData;
    } else {
      var data = json.decode(response.body);
      throw CustomException(data['msg']);
    }
  }

  Future<Map<String, dynamic>> getAnalyticsUseDate(String courseId, String section, DateTime selectedDate) async {
    final Map<String, String> headers = {
      'API_KEY': MyUtils.API_KEY,
      'object_id': teacherModel.objectId,
    };

    final String url = '${MyUtils.baseUrl}/teacherApi/getAnalyticsUseDate?course_id=$courseId&section=$section&date=$selectedDate';
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return jsonData;
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      throw CustomException(data['msg']);
    }
  }

  Future<Map<String, dynamic>> getAnalyticsUseStudentId(String studentId, String courseId) async {
    final Map<String, String> headers = {
      'API_KEY': MyUtils.API_KEY,
      'object_id': teacherModel.objectId,
    };

    final String url = '${MyUtils.baseUrl}/teacherApi/getAnalyticsUseStudentId?student_id=$studentId&course_id=$courseId';
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return jsonData;
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      throw CustomException(data['msg']);
    }
  }

  Future<Map<String, dynamic>> getAnalyticsUseCourseId(String courseId) async {
    final Map<String, String> headers = {
      'API_KEY': MyUtils.API_KEY,
      'object_id': teacherModel.objectId,
    };

    final String url = '${MyUtils.baseUrl}/teacherApi/getAnalyticsUseCourseId?course_id=$courseId';
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return jsonData;
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      throw CustomException(data['msg']);
    }
  }

  Future<List<Map<String, dynamic>>> getStudentsWithWarning(String courseId) async {
    final Map<String, String> headers = {
      'API_KEY': MyUtils.API_KEY,
      'object_id': teacherModel.objectId,
    };

    final String url = '${MyUtils.baseUrl}/teacherApi/getStudentsWithLowAttendanceForAcourse?course_id=$courseId';
    print(url);
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.cast<Map<String, dynamic>>();
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      throw CustomException(data['msg']);
    }
  }

  Future<Map<String, dynamic>> notifyStudentsWithWarning(String courseId) async {
    final Map<String, String> headers = {
      'API_KEY': MyUtils.API_KEY,
      'object_id': teacherModel.objectId,
    };

    final String url = '${MyUtils.baseUrl}/teacherApi/notifyStudentsWithLowAttendanceForAcourse?course_id=$courseId';
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return jsonData;
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      throw CustomException(data['msg']);
    }
  }
}
