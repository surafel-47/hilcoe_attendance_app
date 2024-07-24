import 'dart:convert';

import 'package:hilcoe_attendance_app/Models/CommonModels.dart';
import 'package:hilcoe_attendance_app/Utilies/my_utils.dart';
import 'package:http/http.dart' as http;

class LoginAndSignUpApiServices {
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final Map<String, String> headers = {
      'API_KEY': MyUtils.API_KEY,
    };

    final String url = '${MyUtils.baseUrl}/loginSignUpApi/login?person_password=$password&person_email=$email';
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      throw CustomException(data['msg']);
    }
  }

  Future<Map<String, dynamic>> signUp(String userType, String personId, String email, String password) async {
    final Map<String, String> headers = {
      'API_KEY': MyUtils.API_KEY,
    };

    final String url = '${MyUtils.baseUrl}/loginSignUpApi/signUp?userType=$userType&person_id=$personId&email=$email&password=$password';
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      throw CustomException(data['msg']);
    }
  }

  Future<Map<String, dynamic>> signUpValidateIdNumber(String uniqueId) async {
    final Map<String, String> headers = {
      'API_KEY': MyUtils.API_KEY,
    };

    final String url = '${MyUtils.baseUrl}/loginSignUpApi/SignUpValidateIdNumber?unique_id=$uniqueId';
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      throw CustomException(data['msg']);
    }
  }
}

//----------------------------------
class Template {
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final Map<String, String> headers = {
      // 'Content-Type': 'application/json', // Example content-type header
      'API_KEY': MyUtils.API_KEY,
    };

    var url = Uri.https(MyUtils.baseUrl, '/login?person_password=${password}&person_email=${email}');
    final http.Response response = await http.get(
      url,
      headers: headers,
      // You can also pass the body if necessary:
      // body: json.encode({'email': email, 'password': password}),
    );

    // Handle response
    if (response.statusCode == 200) {
      // If login successful, parse JSON response
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      // If login failed, throw an exception or return null
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }
}
