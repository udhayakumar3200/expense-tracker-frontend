import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/config/env_config.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/utils/logger.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/services/storage_service.dart';
import 'app/services/api_service.dart';
import 'app/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable more detailed Flutter error logging
  FlutterError.onError = (details) {
    AppLogger.error(
      'Flutter Error: ${details.exceptionAsString()}',
      tag: 'FlutterError',
      stackTrace: details.stack,
    );
  };
  
  try {
    AppLogger.info('Starting app initialization...', tag: 'Main');
    await EnvConfig.load();
    AppLogger.info('Environment loaded', tag: 'Main');
    
    await initServices();
    AppLogger.info('All services initialized', tag: 'Main');
    
    runApp(const ExpenseTrackerApp());
  } catch (e, stackTrace) {
    AppLogger.error('Failed to initialize app', tag: 'Main', error: e, stackTrace: stackTrace);
    runApp(ErrorApp(error: e.toString()));
  }
}

Future<void> initServices() async {
  await Get.putAsync<SupabaseService>(() => SupabaseService().init());
  await Get.putAsync<StorageService>(() => StorageService().init());
  await Get.putAsync<ApiService>(() => ApiService().init());
}

class ErrorApp extends StatelessWidget {
  final String error;
  
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Failed to initialize app',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
