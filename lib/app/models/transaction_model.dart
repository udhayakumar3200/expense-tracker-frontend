class TransactionModel {
  final int id;
  final String transactionType;
  final double amount;
  final int fromAccountId;
  final int? toAccountId;
  final String? category;
  final String? description;
  final DateTime transactionDate;
  final int userId;
  final DateTime? createdAt;

  TransactionModel({
    required this.id,
    required this.transactionType,
    required this.amount,
    required this.fromAccountId,
    this.toAccountId,
    this.category,
    this.description,
    required this.transactionDate,
    required this.userId,
    this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int,
      transactionType: json['transaction_type'] as String,
      amount: (json['amount'] as num).toDouble(),
      fromAccountId: json['from_account_id'] as int,
      toAccountId: json['to_account_id'] as int?,
      category: json['category'] as String?,
      description: json['description'] as String?,
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      userId: json['user_id'] as int,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_type': transactionType,
      'amount': amount,
      'from_account_id': fromAccountId,
      'to_account_id': toAccountId,
      'category': category,
      'description': description,
      'transaction_date': transactionDate.toIso8601String(),
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  String get displayType {
    switch (transactionType) {
      case 'expense':
        return 'Expense';
      case 'income':
        return 'Income';
      case 'transfer':
        return 'Transfer';
      default:
        return transactionType;
    }
  }
}
