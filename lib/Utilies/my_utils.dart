// ignore_for_file: non_constant_identifier_names

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/CommonModels.dart';

class MyUtils {
  static String baseUrl = "http://192.168.0.105:3000";

  static String API_KEY = 'KDFNA283490BKJDSADAOSF';

  static Future<void> setLoggedInUserData(String userType, String objectId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', userType);
    await prefs.setString('objectId', objectId);
  }

  static Future<void> clearLoggedInUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userType');
    await prefs.remove('objectId');
  }

  static void validateEmail(String email) {
    email = email.trim();
    if (email.isEmpty) {
      throw CustomException('Email field is empty');
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      throw CustomException('Invalid email format');
    } else {
      return; // Email is valid
    }
  }

  static void validateFullName(String fullName) {
    fullName = fullName.trim();
    if (fullName.isEmpty) {
      throw CustomException('Full name field is empty');
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(fullName)) {
      throw CustomException('Full name must contain only letters and spaces');
    } else {
      return; // Full name is valid
    }
  }

  static void validatePassword(String password) {
    password = password.trim();
    if (password.isEmpty) {
      throw CustomException('Password field is empty');
    } else if (password.length < 6) {
      throw CustomException('Password must be at least 6 characters long');
    } else {
      return; // Password is valid
    }
  }

  static void validatePhoneNumber(String phoneNumber) {
    phoneNumber = phoneNumber.trim();
    if (phoneNumber.isEmpty) {
      throw CustomException('Phone number field is empty');
    } else if (!RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
      throw CustomException('Phone number must contain only digits');
    } else {
      return; // Phone number is valid
    }
  }

  static getFirstName(String fullName) {
    List<String> nameParts = fullName.split(' ');
    return nameParts.isNotEmpty ? nameParts.first : fullName;
  }

  static String getCurrentTime() {
    // Create a DateFormat instance with the desired time format
    final timeFormat = DateFormat('h:mm a');

    // Get the current time
    final currentTime = DateTime.now();

    // Format the current time using the DateFormat instance
    final formattedTime = timeFormat.format(currentTime);
    return formattedTime;
  }

  static String getTimeFromDataTime(String dateTimeString) {
    // Parse the DateTime string
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Calculate the difference in days from now
    DateTime now = DateTime.now();
    int daysDifference = dateTime.difference(now).inDays;
    // If the date is more than a day from now, format it as 'MMM d'
    if (daysDifference != 0) {
      return DateFormat('MMM d').format(dateTime);
    }

    // Otherwise, format it as 'hh:mm a'
    return DateFormat('hh:mm a').format(dateTime);
  }
}
