import 'package:get/get.dart';
import 'app_routes.dart';
import '../bindings/auth_binding.dart';
import '../bindings/account_binding.dart';
import '../bindings/transaction_binding.dart';
import '../modules/splash/splash_screen.dart';
import '../modules/auth/login_screen.dart';
import '../modules/main/main_binding.dart';
import '../modules/main/main_screen.dart';
import '../modules/accounts/add_account_screen.dart';
import '../modules/transactions/add_transaction_screen.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const MainScreen(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.addAccount,
      page: () => const AddAccountScreen(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: AppRoutes.addTransaction,
      page: () => const AddTransactionScreen(),
      binding: TransactionBinding(),
    ),
  ];
}
