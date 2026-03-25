import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/auth/update_user_request.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/service/api_service.dart';
import 'package:gastrorate/tools/services_uri_helper.dart';

class UserManager {
  static const String UPLOAD_PROFILE_IMAGE = "/user/{userId}/upload-profile-image";
  static const String UPDATE_USER = "/user/{userId}";

  static final UserManager _singleton = UserManager._internal();

  factory UserManager() {
    return _singleton;
  }

  UserManager._internal();

  Dio client = Dio();
  Dio authClient = ApiService.client;

  Future<String> uploadProfileImage(File file, String userId) async {
    final Map<String, dynamic> params = {"userId": userId};
    final String url = ServicesUriHelper.getUrlWithParams(
      "${dotenv.env['API_BASE_URI']}$UPLOAD_PROFILE_IMAGE",
      params,
    );

    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: file.uri.pathSegments.last,
      ),
    });
    final response = await client.post(url, data: formData);

    return response.data.toString();
  }

  Future<User?> updateUser(String userId, UpdateUserRequest request) async {
    final Map<String, dynamic> params = {"userId": userId};
    final String url = ServicesUriHelper.getUrlWithParams(
      "${dotenv.env['API_BASE_URI']}$UPDATE_USER",
      params,
    );
    final response = await authClient.patch(url, data: request.toJson());
    return User.fromJson(response.data);
  }
}
