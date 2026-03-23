import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/auth/auth_response.dart';
import 'package:gastrorate/models/auth/login_request.dart';
import 'package:gastrorate/models/auth/register_request.dart';
import 'package:gastrorate/models/auth/update_user_request.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/service/api_service.dart';

class AuthManager {
  static const String LOGIN = "/auth/login";
  static const String REGISTER = "/auth/register";
  static const String LOGOUT = "/auth/logout";
  static const String UPDATE_USER = "/user/";

  static final AuthManager _singleton = AuthManager._internal();

  factory AuthManager() {
    return _singleton;
  }

  AuthManager._internal();

  Dio client = Dio();

  Future<AuthResponse?> login(LoginRequest loginRequest) async {
    try {
      String url = dotenv.env['API_BASE_URI'].toString() + LOGIN;
      final Response<dynamic> response = await client.post(url, data: loginRequest.toJson());
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      print("Login failed: $e");
      return null;
    }
  }


  Future<bool> register(RegisterRequest registerRequest) async {
    try {
      String url = dotenv.env['API_BASE_URI'].toString() + REGISTER;
      final response = await client.post(url, data: registerRequest.toJson());
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      print('Registration failed: ${e.response?.data}');
      return false;
    }
  }

  Future<User?> updateUser(String userId, UpdateUserRequest request) async {
    try {
      String url = dotenv.env['API_BASE_URI'].toString() + UPDATE_USER + userId;
      final response = await ApiService.client.patch(url, data: request.toJson());
      return User.fromJson(response.data);
    } on DioException catch (e) {
      print('Update user failed: ${e.response?.data}');
      return null;
    }
  }
}
