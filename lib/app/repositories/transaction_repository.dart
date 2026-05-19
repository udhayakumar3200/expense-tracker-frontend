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
      return ApiResponse.error('Failed to create transaction',
          statusCode: response.statusCode);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<List<TransactionModel>>> getTransactions({
    int limit = 20,
    int offset = 0,
    String? transactionType,
    String? fromAccountId,
    String? categoryId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'limit': limit,
        'offset': offset,
        'transaction_type': ?transactionType,
        'from_account_id': ?fromAccountId,
        'category_id': ?categoryId,
        if (dateFrom != null) 'date_from': dateFrom.toIso8601String(),
        if (dateTo != null) 'date_to': dateTo.toIso8601String(),
      };
      final response = await _apiService.get(
        ApiEndpoints.getTransactions,
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        final transactions = data
            .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(transactions, statusCode: response.statusCode);
      }
      return ApiResponse.error('Failed to fetch transactions',
          statusCode: response.statusCode);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<TransactionModel>> getTransaction(String id) async {
    try {
      final response =
          await _apiService.get('${ApiEndpoints.getTransaction}/$id');
      if (response.statusCode == 200) {
        final transaction =
            TransactionModel.fromJson(response.data as Map<String, dynamic>);
        return ApiResponse.success(transaction, statusCode: response.statusCode);
      }
      return ApiResponse.error('Failed to fetch transaction',
          statusCode: response.statusCode);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<TransactionModel>> updateTransaction(
      String id, TransactionUpdateRequest request) async {
    try {
      final response = await _apiService.patch(
        '${ApiEndpoints.updateTransaction}/$id',
        data: request.toJson(),
      );
      if (response.statusCode == 200) {
        final transaction =
            TransactionModel.fromJson(response.data as Map<String, dynamic>);
        return ApiResponse.success(transaction, statusCode: response.statusCode);
      }
      return ApiResponse.error('Failed to update transaction',
          statusCode: response.statusCode);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<void>> deleteTransaction(String id) async {
    try {
      final response =
          await _apiService.delete('${ApiEndpoints.deleteTransaction}/$id');
      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 202) {
        return ApiResponse.success(null, statusCode: response.statusCode);
      }
      return ApiResponse.error('Failed to delete transaction',
          statusCode: response.statusCode);
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
