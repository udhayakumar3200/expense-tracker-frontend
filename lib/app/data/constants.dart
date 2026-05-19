class ApiConfig {
  ApiConfig._();
}

class ApiEndpoints {
  ApiEndpoints._();

  // Public
  static const String health = '/health';

  // Accounts
  static const String createAccount  = '/api/accounts/create_account';
  static const String getAccounts    = '/api/accounts/get_accounts';
  static const String getAccount     = '/api/accounts/get_account';
  static const String updateAccount  = '/api/accounts/update_account';
  static const String deleteAccount  = '/api/accounts/delete_account';

  // Categories
  static const String createCategory = '/api/categories/create_category';
  static const String getCategories  = '/api/categories/get_categories';
  static const String getCategory    = '/api/categories/get_category';
  static const String updateCategory = '/api/categories/update_category';

  // Transactions
  static const String createTransaction = '/api/transactions/create_transaction';
  static const String getTransactions   = '/api/transactions/get_transactions';
  static const String getTransaction    = '/api/transactions/get_transaction';
  static const String updateTransaction = '/api/transactions/update_transaction';
  static const String deleteTransaction = '/api/transactions/delete_transaction';
}

class StorageKeys {
  StorageKeys._();
  
  static const String jwtToken = 'jwt_token';
  static const String userData = 'user_data';
}
