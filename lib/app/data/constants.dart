class ApiEndpoints {
  ApiEndpoints._();
  
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String accounts = '/accounts';
  static const String transactions = '/transactions';
}

class StorageKeys {
  StorageKeys._();
  
  static const String jwtToken = 'jwt_token';
  static const String userData = 'user_data';
}
