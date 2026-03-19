import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../data/constants.dart';

class StorageService extends GetxService {
  late FlutterSecureStorage _storage;

  Future<StorageService> init() async {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
    return this;
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConstants.jwtKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.jwtKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: AppConstants.jwtKey);
  }

  Future<void> saveUserData(String userData) async {
    await _storage.write(key: AppConstants.userKey, value: userData);
  }

  Future<String?> getUserData() async {
    return await _storage.read(key: AppConstants.userKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
