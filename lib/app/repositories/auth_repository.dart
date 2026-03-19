import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/utils/logger.dart';
import '../models/api_response.dart';
import '../models/user_model.dart';
import '../services/supabase_service.dart';
import '../services/storage_service.dart';

class AuthRepository {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  final StorageService _storageService = Get.find<StorageService>();

  static const String _tag = 'AuthRepository';

  Future<ApiResponse<UserModel>> login(String email, String password) async {
    AppLogger.info('Attempting login for: $email', tag: _tag);
    try {
      final response = await _supabaseService.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        AppLogger.info('Login successful for: $email', tag: _tag);
        final user = UserModel(
          id: response.user!.id.hashCode,
          email: response.user!.email ?? email,
          name: response.user!.userMetadata?['name'] as String?,
        );

        if (response.session?.accessToken != null) {
          await _storageService.saveToken(response.session!.accessToken);
        }

        return ApiResponse.success(user);
      }

      AppLogger.warning('Login failed - no user returned', tag: _tag);
      return ApiResponse.error('Login failed');
    } on AuthException catch (e) {
      AppLogger.error('Auth exception during login', tag: _tag, error: e.message);
      return ApiResponse.error(e.message);
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during login', tag: _tag, error: e, stackTrace: stackTrace);
      return ApiResponse.error('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<UserModel>> register(
    String email,
    String password, {
    String? name,
  }) async {
    AppLogger.info('Attempting registration for: $email', tag: _tag);
    try {
      final response = await _supabaseService.auth.signUp(
        email: email,
        password: password,
        data: name != null ? {'name': name} : null,
      );

      if (response.user != null) {
        AppLogger.info('Registration successful for: $email', tag: _tag);
        final user = UserModel(
          id: response.user!.id.hashCode,
          email: response.user!.email ?? email,
          name: name,
        );
        return ApiResponse.success(user);
      }

      AppLogger.warning('Registration failed - no user returned', tag: _tag);
      return ApiResponse.error('Registration failed');
    } on AuthException catch (e) {
      AppLogger.error('Auth exception during registration', tag: _tag, error: e.message);
      return ApiResponse.error(e.message);
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during registration', tag: _tag, error: e, stackTrace: stackTrace);
      return ApiResponse.error('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    await _supabaseService.auth.signOut();
    await _storageService.clearAll();
  }

  Future<bool> isLoggedIn() async {
    return _supabaseService.isAuthenticated;
  }

  User? get currentUser => _supabaseService.currentUser;
}
