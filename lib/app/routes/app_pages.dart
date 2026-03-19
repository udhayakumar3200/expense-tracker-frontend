import 'package:get/get.dart';
import 'app_routes.dart';
import '../bindings/auth_binding.dart';
import '../bindings/dashboard_binding.dart';
import '../bindings/account_binding.dart';
import '../bindings/transaction_binding.dart';
import '../modules/splash/splash_screen.dart';
import '../modules/auth/login_screen.dart';
import '../modules/dashboard/dashboard_screen.dart';
import '../modules/accounts/add_account_screen.dart';
import '../modules/transactions/add_transaction_screen.dart';
import '../modules/transactions/transaction_list_screen.dart';

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
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
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
    GetPage(
      name: AppRoutes.transactionList,
      page: () => const TransactionListScreen(),
      binding: TransactionBinding(),
    ),
  ];
}
