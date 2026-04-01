import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'auth_service.dart';

// lib/services/api_service.dart

class ApiService {
  late Dio _dio;
  final AuthService _auth = AuthService();

  // 1. Create a static instance
  static final ApiService _instance = ApiService._internal();

  // 2. Factory constructor returns the same instance every time
  factory ApiService() => _instance;

  // 3. Private internal constructor where setup happens
  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:8000',
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _auth.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<Response> post(String path, dynamic data) => _dio.post(path, data: data);
  Future<Response> get(String path) => _dio.get(path);
}