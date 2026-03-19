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
    await _storage.write(key: StorageKeys.jwtToken, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: StorageKeys.jwtToken);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: StorageKeys.jwtToken);
  }

  Future<void> saveUserData(String userData) async {
    await _storage.write(key: StorageKeys.userData, value: userData);
  }

  Future<String?> getUserData() async {
    return await _storage.read(key: StorageKeys.userData);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
