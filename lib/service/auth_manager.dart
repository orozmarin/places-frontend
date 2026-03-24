import 'dart:io';
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
      return normalizeUser(User.fromJson(response.data));
    } on DioException catch (e) {
      print('Update user failed: ${e.response?.data}');
      return null;
    }
  }

  Future<String?> uploadProfileImage(String userId, File imageFile) async {
    try {
      String url = dotenv.env['API_BASE_URI'].toString() + UPDATE_USER + userId + '/upload-profile-image';
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path, filename: imageFile.path.split('/').last),
      });
      final response = await ApiService.client.post(url, data: formData);
      return _normalizeImageUrl(response.data as String?);
    } on DioException catch (e) {
      print('Upload profile image failed: ${e.response?.data}');
      return null;
    }
  }

  /// Converts a relative image path (e.g. /uploads/file.jpg) to a full URL.
  static User normalizeUser(User user) {
    return user.copyWith(profileImageUrl: _normalizeImageUrl(user.profileImageUrl));
  }

  static String? _normalizeImageUrl(String? url) {
    if (url == null || url.startsWith('http')) return url;
    final apiBase = dotenv.env['API_BASE_URI'] ?? '';
    final uri = Uri.tryParse(apiBase);
    if (uri == null) return url;
    return '${uri.scheme}://${uri.host}:${uri.port}$url';
  }
}
