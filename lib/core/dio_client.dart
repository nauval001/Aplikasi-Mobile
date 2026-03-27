import 'package:dio/dio.dart';
import 'local_storage_service.dart';

class DioClient {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  final Dio dio;
  final LocalStorageService _localStorage;

  DioClient({LocalStorageService? localStorage})
      : _localStorage = localStorage ?? LocalStorageService(),
        dio = Dio(
          BaseOptions(
            baseUrl: _baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {'Accept': 'application/json'},
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _localStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }
}