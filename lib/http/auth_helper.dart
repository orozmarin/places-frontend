import 'dart:convert';

import 'package:gastrorate/models/auth/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper{
  static Future<void> storeToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);  // Save the JWT token to SharedPreferences
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');  // Retrieve the JWT token from SharedPreferences
  }

  static Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');  // Remove the JWT token
  }

  static Future<void> storeUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('logged_user', jsonEncode(user.toJson()));  // Save the logged in user to SharedPreferences
  }

  static Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedUserJson = prefs.getString('logged_user');
    if (loggedUserJson != null && loggedUserJson.isNotEmpty){
      return User.fromJson(jsonDecode(loggedUserJson)); // Retrieve the logged in user from SharedPreferences
    }
    return null;
  }

  static Future<void> removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_user');  // Remove the logged in user
  }
}