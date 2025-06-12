import 'package:dio/dio.dart';
import 'package:gastrorate/http/auth_helper.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await AuthHelper.getToken();

    if (token != null) {
      // Add the Authorization header with the token
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Continue with the request
    return super.onRequest(options, handler);
  }
}
