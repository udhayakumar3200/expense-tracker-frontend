import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../data/constants.dart';
import '../models/api_response.dart';
import '../models/transaction_model.dart';
import '../services/api_service.dart';

class TransactionRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponse<TransactionModel>> createTransaction({
    required String transactionType,
    required double amount,
    String? fromAccountId,
    String? toAccountId,
    String? categoryId,
    String? description,
    required DateTime transactionDate,
  }) async {
    try {
      final request = TransactionCreateRequest(
        amount: amount,
        type: TransactionTypeX.fromApi(transactionType),
        transactionDate: transactionDate,
        fromAccountId: fromAccountId,
        toAccountId: toAccountId,
        categoryId: categoryId,
        description: description,
      );

      final response = await _apiService.post(
        ApiEndpoints.createTransaction,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final transaction =
            TransactionModel.fromJson(response.data as Map<String, dynamic>);
        return ApiResponse.success(transaction, statusCode: response.statusCode);
      }

      return ApiResponse.error(
        'Failed to create transaction',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<List<TransactionModel>>> getTransactions() async {
    return ApiResponse.error(
      'GET transactions endpoint is not provided in current API spec',
    );
  }

  ApiResponse<T> _handleDioError<T>(DioException e) {
    final message = ApiService.extractErrorMessage(e);
    return ApiResponse.error(message, statusCode: e.response?.statusCode);
  }
}
