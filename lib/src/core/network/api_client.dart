import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../observability/app_logger.dart';
import '../security/secure_storage_service.dart';

/// Clean Architecture API Network Client for PetConnect AI Ecosystem
class ApiClient {
  late final Dio dio;
  final SecureStorageService secureStorage;

  ApiClient({required this.secureStorage}) {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.instance.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = secureStorage.getAuthToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          AppLogger.debug('🌐 Request [${options.method}] => ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.debug('✅ Response [${response.statusCode}] <= ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          AppLogger.error('❌ Network Exception: ${e.message}', e, e.stackTrace);
          if (e.response?.statusCode == 401) {
            // Token refresh logic placeholder
            AppLogger.warning('Token expired, triggering refresh sequence...');
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await dio.delete(path);
  }
}
