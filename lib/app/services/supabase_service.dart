import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/config/env_config.dart';
import '../core/utils/logger.dart';

class SupabaseService extends GetxService {
  late SupabaseClient _client;

  static const String _tag = 'SupabaseService';

  SupabaseClient get client => _client;
  
  GoTrueClient get auth => _client.auth;

  User? get currentUser => _client.auth.currentUser;

  bool get isAuthenticated => currentUser != null;

  Future<SupabaseService> init() async {
    AppLogger.info('Initializing Supabase...', tag: _tag);
    AppLogger.debug('URL: ${EnvConfig.supabaseUrl}', tag: _tag);
    
    try {
      await Supabase.initialize(
        url: EnvConfig.supabaseUrl,
        anonKey: EnvConfig.supabaseAnonKey,
      );
      _client = Supabase.instance.client;
      AppLogger.info('Supabase initialized successfully', tag: _tag);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize Supabase', tag: _tag, error: e, stackTrace: stackTrace);
      rethrow;
    }
    return this;
  }

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
