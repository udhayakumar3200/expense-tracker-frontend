enum AccountType { upi, bank, cash, creditCard }

extension AccountTypeX on AccountType {
  String get apiValue {
    switch (this) {
      case AccountType.upi:
        return 'upi';
      case AccountType.bank:
        return 'bank';
      case AccountType.cash:
        return 'cash';
      case AccountType.creditCard:
        return 'credit_card';
    }
  }

  static AccountType fromApi(String value) {
    switch (value) {
      case 'upi':
        return AccountType.upi;
      case 'bank':
        return AccountType.bank;
      case 'cash':
        return AccountType.cash;
      case 'credit_card':
        return AccountType.creditCard;
      default:
        return AccountType.cash;
    }
  }
}

class AccountModel {
  final String id;
  final String userId;
  final String name;
  final AccountType type;
  final double currentBalance;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AccountModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.currentBalance,
    this.createdAt,
    this.updatedAt,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: (json['id'] ?? '').toString(),
      userId: (json['user_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      type: AccountTypeX.fromApi((json['type'] ?? '').toString()),
      currentBalance: _toDouble(json['current_balance']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'type': type.apiValue,
      'current_balance': currentBalance,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Compatibility getters for existing UI code.
  String get accountType => type.apiValue;
  double get balance => currentBalance;

  String get displayType {
    switch (type) {
      case AccountType.bank:
        return 'Bank Account';
      case AccountType.cash:
        return 'Cash';
      case AccountType.upi:
        return 'UPI';
      case AccountType.creditCard:
        return 'Credit Card';
    }
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}

class AccountCreateRequest {
  final String name;
  final AccountType type;
  final double? initialBalance;

  const AccountCreateRequest({
    required this.name,
    required this.type,
    this.initialBalance,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.apiValue,
      if (initialBalance != null) 'initial_balance': initialBalance,
    };
  }
}
