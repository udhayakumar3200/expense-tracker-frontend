import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../data/constants.dart';
import '../models/api_response.dart';
import '../models/transaction_model.dart';
import '../services/api_service.dart';

class TransactionRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponse<List<TransactionModel>>> getTransactions() async {
    try {
      final response = await _apiService.get(ApiEndpoints.transactions);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final transactions =
            data.map((e) => TransactionModel.fromJson(e)).toList();
        return ApiResponse.success(transactions, statusCode: response.statusCode);
      }

      return ApiResponse.error(
        'Failed to fetch transactions',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<TransactionModel>> createTransaction({
    required String transactionType,
    required double amount,
    required int fromAccountId,
    int? toAccountId,
    String? category,
    String? description,
    required DateTime transactionDate,
  }) async {
    try {
      final data = {
        'transaction_type': transactionType,
        'amount': amount,
        'from_account_id': fromAccountId,
        'transaction_date': transactionDate.toIso8601String().split('T')[0],
      };

      if (toAccountId != null) {
        data['to_account_id'] = toAccountId;
      }
      if (category != null && category.isNotEmpty) {
        data['category'] = category;
      }
      if (description != null && description.isNotEmpty) {
        data['description'] = description;
      }

      final response = await _apiService.post(
        ApiEndpoints.transactions,
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final transaction = TransactionModel.fromJson(response.data);
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
