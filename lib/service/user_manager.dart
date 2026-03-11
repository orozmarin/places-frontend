import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/tools/services_uri_helper.dart';

class UserManager {
  static const String UPLOAD_PROFILE_IMAGE = "/user/{userId}/upload-profile-image";

  static final UserManager _singleton = UserManager._internal();

  factory UserManager() {
    return _singleton;
  }

  UserManager._internal();

  Dio client = Dio();

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
}
