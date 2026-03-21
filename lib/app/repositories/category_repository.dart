import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../data/constants.dart';
import '../models/api_response.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class CategoryRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponse<List<CategoryModel>>> getCategories() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getCategories);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final categories = data
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(categories, statusCode: response.statusCode);
      }

      return ApiResponse.error(
        'Failed to fetch categories',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        ApiService.extractErrorMessage(e),
        statusCode: e.response?.statusCode,
      );
    } catch (_) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<CategoryModel>> createCategory({
    required String name,
    required String type,
  }) async {
    try {
      final request = CategoryCreateRequest(
        name: name,
        type: CategoryTypeX.fromApi(type),
      );
      final response = await _apiService.post(
        ApiEndpoints.createCategory,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final category = CategoryModel.fromJson(response.data as Map<String, dynamic>);
        return ApiResponse.success(category, statusCode: response.statusCode);
      }

      return ApiResponse.error(
        'Failed to create category',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        ApiService.extractErrorMessage(e),
        statusCode: e.response?.statusCode,
      );
    } catch (_) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }
}
