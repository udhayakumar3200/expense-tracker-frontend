import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../data/constants.dart';
import '../models/api_response.dart';
import '../models/account_model.dart';
import '../services/api_service.dart';

class AccountRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponse<List<AccountModel>>> getAccounts() async {
    try {
      final response = await _apiService.get(ApiEndpoints.accounts);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final accounts = data.map((e) => AccountModel.fromJson(e)).toList();
        return ApiResponse.success(accounts, statusCode: response.statusCode);
      }

      return ApiResponse.error(
        'Failed to fetch accounts',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<AccountModel>> createAccount({
    required String name,
    required String accountType,
    required double balance,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.accounts,
        data: {
          'name': name,
          'account_type': accountType,
          'balance': balance,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final account = AccountModel.fromJson(response.data);
        return ApiResponse.success(account, statusCode: response.statusCode);
      }

      return ApiResponse.error(
        'Failed to create account',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<AccountModel>> getAccountById(int id) async {
    try {
      final response = await _apiService.get('${ApiEndpoints.accounts}/$id');

      if (response.statusCode == 200) {
        final account = AccountModel.fromJson(response.data);
        return ApiResponse.success(account, statusCode: response.statusCode);
      }

      return ApiResponse.error(
        'Failed to fetch account',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  ApiResponse<T> _handleDioError<T>(DioException e) {
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
