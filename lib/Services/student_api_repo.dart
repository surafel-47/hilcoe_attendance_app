import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hilcoe_attendance_app/Models/StudentModels.dart';
import 'package:hilcoe_attendance_app/Utilies/my_utils.dart';
import 'package:http/http.dart' as http;

import '../Models/CommonModels.dart';

class StudentApiRepo extends ChangeNotifier {
  StudentApiRepo({required this.studentModel});

  StudentModel studentModel;

  Future<Map<String, dynamic>> setPassword(String newPassWord) async {
    final Map<String, String> headers = {
      'API_KEY': MyUtils.API_KEY,
      'object_id': studentModel.objectId,
    };

    final String url = '${MyUtils.baseUrl}/studentApi/setNewPassword?new_password=$newPassWord';
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

  Future<Map<String, dynamic>> clearNotification(String courseId, String date) async {
    final Map<String, String> headers = {
      'API_KEY': MyUtils.API_KEY,
      'object_id': studentModel.objectId,
    };

    final String url = '${MyUtils.baseUrl}/studentApi/clearSingleNotification?course_id=$courseId&date=$date';
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

  Future<List<Map<String, dynamic>>> getRecentAttendance() async {
    final Map<String, String> headers = {
      'API_KEY': MyUtils.API_KEY,
      'object_id': studentModel.objectId,
    };

    final String url = '${MyUtils.baseUrl}/studentApi/getRecentAttendance';
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

  Future<dynamic> getNotifications() async {
    final Map<String, String> headers = {
      'API_KEY': MyUtils.API_KEY,
      'object_id': studentModel.objectId,
    };

    final String url = '${MyUtils.baseUrl}/studentApi/getNotifications';
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
