import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../data/constants.dart';
import '../models/api_response.dart';
import '../services/api_service.dart';

class HealthRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponse<String>> healthCheck() async {
    try {
      final response = await _apiService.get(ApiEndpoints.health);
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return ApiResponse.success((data['status'] ?? '').toString());
      }
      return ApiResponse.error(
        'Health check failed',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        ApiService.extractErrorMessage(e),
        statusCode: e.response?.statusCode,
      );
    } catch (_) {
      return ApiResponse.error('Unexpected health check error');
    }
  }
}
