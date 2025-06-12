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
}