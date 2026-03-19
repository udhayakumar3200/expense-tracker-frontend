import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../data/constants.dart';
import '../models/api_response.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthRepository {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  Future<ApiResponse<UserModel>> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        AppConstants.loginEndpoint,
        data: {
          'username': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['access_token'] as String;
        await _storageService.saveToken(token);
        
        final user = UserModel(
          id: data['user_id'] ?? 0,
          email: email,
        );
        
        return ApiResponse.success(user, statusCode: response.statusCode);
      }
      
      return ApiResponse.error(
        'Login failed',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<UserModel>> register(
    String email,
    String password, {
    String? name,
  }) async {
    try {
      final response = await _apiService.post(
        AppConstants.registerEndpoint,
        data: {
          'email': email,
          'password': password,
          if (name != null) 'name': name,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final user = UserModel.fromJson(data);
        return ApiResponse.success(user, statusCode: response.statusCode);
      }
      
      return ApiResponse.error(
        'Registration failed',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<void> logout() async {
    await _storageService.clearAll();
  }

  Future<bool> isLoggedIn() async {
    return await _storageService.hasToken();
  }

  ApiResponse<UserModel> _handleDioError(DioException e) {
    String message;
    
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map && data['detail'] != null) {
        message = data['detail'].toString();
      } else {
        message = 'Request failed with status ${e.response?.statusCode}';
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      message = 'Connection timeout. Please check your internet connection.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      message = 'Server is taking too long to respond.';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'Unable to connect to server. Please check your internet.';
    } else {
      message = 'Network error occurred';
    }

    return ApiResponse.error(message, statusCode: e.response?.statusCode);
  }
}
