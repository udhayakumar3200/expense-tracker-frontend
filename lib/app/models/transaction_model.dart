enum TransactionType { expense, income, transfer }

extension TransactionTypeX on TransactionType {
  String get apiValue {
    switch (this) {
      case TransactionType.expense:
        return 'expense';
      case TransactionType.income:
        return 'income';
      case TransactionType.transfer:
        return 'transfer';
    }
  }

  static TransactionType fromApi(String value) {
    switch (value) {
      case 'expense':
        return TransactionType.expense;
      case 'income':
        return TransactionType.income;
      case 'transfer':
        return TransactionType.transfer;
      default:
        return TransactionType.expense;
    }
  }
}

class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final TransactionType type;
  final DateTime transactionDate;
  final String? fromAccountId;
  final String? toAccountId;
  final String? categoryId;
  final String? description;
  final DateTime? createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.transactionDate,
    this.fromAccountId,
    this.toAccountId,
    this.categoryId,
    this.description,
    this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: (json['id'] ?? '').toString(),
      userId: (json['user_id'] ?? '').toString(),
      amount: _toDouble(json['amount']),
      type: TransactionTypeX.fromApi((json['type'] ?? '').toString()),
      transactionDate: DateTime.parse((json['transaction_date'] ?? '').toString()),
      fromAccountId: json['from_account_id']?.toString(),
      toAccountId: json['to_account_id']?.toString(),
      categoryId: json['category_id']?.toString(),
      description: json['description'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'type': type.apiValue,
      'transaction_date': transactionDate.toIso8601String(),
      'from_account_id': fromAccountId,
      'to_account_id': toAccountId,
      'category_id': categoryId,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // Compatibility getters for existing UI code.
  String get transactionType => type.apiValue;
  String? get category => null;

  String get displayType {
    switch (type) {
      case TransactionType.expense:
        return 'Expense';
      case TransactionType.income:
        return 'Income';
      case TransactionType.transfer:
        return 'Transfer';
    }
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}

class TransactionCreateRequest {
  final double amount;
  final TransactionType type;
  final DateTime transactionDate;
  final String? fromAccountId;
  final String? toAccountId;
  final String? categoryId;
  final String? description;

  const TransactionCreateRequest({
    required this.amount,
    required this.type,
    required this.transactionDate,
    this.fromAccountId,
    this.toAccountId,
    this.categoryId,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type.apiValue,
      'transaction_date': transactionDate.toIso8601String(),
      if (fromAccountId != null) 'from_account_id': fromAccountId,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (categoryId != null) 'category_id': categoryId,
      if (description != null && description!.isNotEmpty) 'description': description,
    };
  }
}
