class ApiConfig {
  ApiConfig._();
}

class ApiEndpoints {
  ApiEndpoints._();

  // Public
  static const String health = '/health';

  // Protected /api/*
  static const String createAccount = '/api/accounts/create_account';
  static const String getAccounts = '/api/accounts/get_accounts';
  static const String createCategory = '/api/categories/create_category';
  static const String getCategories = '/api/categories/get_categories';
  static const String createTransaction = '/api/transactions/create_transaction';
}

class StorageKeys {
  StorageKeys._();
  
  static const String jwtToken = 'jwt_token';
  static const String userData = 'user_data';
}
