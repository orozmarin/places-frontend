import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/auth/auth_response.dart';
import 'package:gastrorate/models/auth/login_request.dart';
import 'package:gastrorate/models/auth/register_request.dart';

class AuthManager {
  static const String LOGIN = "/auth/login";
  static const String REGISTER = "/auth/register";

  static final AuthManager _singleton = AuthManager._internal();

  factory AuthManager() {
    return _singleton;
  }

  AuthManager._internal();

  Dio client = Dio();

  Future<AuthResponse> login(LoginRequest loginRequest) async {
    String url = dotenv.env['API_BASE_URI'].toString() + LOGIN;
    final Response<dynamic> response = await client.post(url, data: loginRequest.toJson());
    return AuthResponse.fromJson(response.data);
  }

  Future<void> register(RegisterRequest registerRequest) async {
    String url = dotenv.env['API_BASE_URI'].toString() + REGISTER;
    final Response<dynamic> response = await client.post(url, data: registerRequest.toJson());
    return;
  }
}
