import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../core/config/env_config.dart';
import '../core/utils/logger.dart';
import 'supabase_service.dart';
import 'storage_service.dart';
import '../routes/app_routes.dart';

class ApiService extends GetxService {
  late Dio _dio;
  final StorageService _storageService = Get.find<StorageService>();
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  static const String _tag = 'ApiService';

  Future<ApiService> init() async {
    _dio = Dio(BaseOptions(
      baseUrl: EnvConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final isProtectedApi = options.path.startsWith('/api/');

        // /api/* endpoints must always carry Supabase access token.
        if (isProtectedApi) {
          final token = _supabaseService.auth.currentSession?.accessToken ??
              await _storageService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }

        if (options.method.toUpperCase() == 'POST') {
          options.headers['Content-Type'] = 'application/json';
        }

        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 &&
            error.requestOptions.path.startsWith('/api/')) {
          AppLogger.warning('401 unauthorized, redirecting to login', tag: _tag);
          await _storageService.clearAll();
          Get.offAllNamed(AppRoutes.login);
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: 'Session expired. Please login again.',
              message: 'Session expired. Please login again.',
            ),
          );
        }

        if (error.response?.statusCode == 400) {
          final message = extractErrorMessage(error);
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: message,
              message: message,
            ),
          );
        }
        return handler.next(error);
      },
    ));

    return this;
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.put(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.delete(path, queryParameters: queryParameters);
  }

  static String extractErrorMessage(DioException error) {
    final responseData = error.response?.data;
    if (responseData is Map<String, dynamic>) {
      final detail = responseData['detail'];
      if (detail != null) {
        if (detail is String) return detail;
        if (detail is List && detail.isNotEmpty) {
          return detail.map((e) => e.toString()).join(', ');
        }
        return detail.toString();
      }
    }
    return error.message ?? 'Request failed';
  }
}
