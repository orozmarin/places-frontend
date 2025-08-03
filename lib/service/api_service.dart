import 'package:dio/dio.dart';
import 'package:gastrorate/http/auth_interceptor.dart';

class ApiService {
  // Singleton Dio client
  static final Dio _client = Dio()
    ..interceptors.add(AuthInterceptor());

  // Getter for the Dio client
  static Dio get client => _client;
}
