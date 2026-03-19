class AccountModel {
  final int id;
  final String name;
  final String accountType;
  final double balance;
  final int userId;
  final DateTime? createdAt;

  AccountModel({
    required this.id,
    required this.name,
    required this.accountType,
    required this.balance,
    required this.userId,
    this.createdAt,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as int,
      name: json['name'] as String,
      accountType: json['account_type'] as String,
      balance: (json['balance'] as num).toDouble(),
      userId: json['user_id'] as int,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'account_type': accountType,
      'balance': balance,
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  String get displayType {
    switch (accountType) {
      case 'bank':
        return 'Bank Account';
      case 'cash':
        return 'Cash';
      case 'upi':
        return 'UPI';
      case 'credit_card':
        return 'Credit Card';
      default:
        return accountType;
    }
  }
}
