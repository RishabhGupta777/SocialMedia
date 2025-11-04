import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktok_clone/College/view/screens/attendence_login_screen.dart';
import 'package:tiktok_clone/College/view/screens/show_attendance_screen.dart';

class AttendanceProvider with ChangeNotifier {
  bool isLoading = true;

  /// Check if saved login exists and auto-navigate
  Future<void> checkSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    final savedPassword = prefs.getString('password');

    if (savedUsername != null && savedPassword != null) {
      Get.off(() => ShowAttendanceScreen(
        username: savedUsername,
        password: savedPassword,
      ));
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Save login only after successful verification
  Future<void> saveLogin(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  /// Optional logout function
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    Get.off(()=>AttendanceLoginScreen());
  }
}
