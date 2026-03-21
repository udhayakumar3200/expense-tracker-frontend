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
      final response = await _apiService.get(ApiEndpoints.getAccounts);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final accounts = data
            .map((e) => AccountModel.fromJson(e as Map<String, dynamic>))
            .toList();
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
      final parsedType = AccountTypeX.fromApi(accountType);
      final request = AccountCreateRequest(
        name: name,
        type: parsedType,
        initialBalance: balance,
      );
      final response = await _apiService.post(
        ApiEndpoints.createAccount,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final account = AccountModel.fromJson(response.data as Map<String, dynamic>);
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

  ApiResponse<T> _handleDioError<T>(DioException e) {
    final message = ApiService.extractErrorMessage(e);
    return ApiResponse.error(message, statusCode: e.response?.statusCode);
  }
}
