import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/account_tile.dart';
import '../../widgets/section_header.dart';
import '../../widgets/empty_state.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () => Get.toNamed(AppRoutes.transactionList),
            tooltip: 'Transactions',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showLogoutDialog,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return EmptyState(
            icon: Icons.error_outline,
            title: 'Something went wrong',
            subtitle: controller.errorMessage.value,
            buttonText: 'Retry',
            onButtonPressed: controller.refreshData,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: ListView(
            padding: AppSpacing.screenPadding,
            children: [
              Obx(() => BalanceCard(
                    balance: controller.totalBalance.value,
                    title: 'Total Balance',
                    subtitle: '${controller.accounts.length} accounts',
                    icon: Icons.account_balance_wallet,
                  )),
              AppSpacing.verticalLg,
              SectionHeader(
                title: 'Accounts',
                subtitle: '${controller.accounts.length} accounts',
              ),
              AppSpacing.verticalSm,
              if (controller.accounts.isEmpty)
                const EmptyState(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'No accounts yet',
                  subtitle: 'Add your first account to get started',
                )
              else
                ...controller.accounts.map(
                  (account) => AccountTile(account: account),
                ),
            ],
          ),
        );
      }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'addAccount',
            onPressed: () => Get.toNamed(AppRoutes.addAccount),
            tooltip: 'Add Account',
            backgroundColor: AppColors.secondary,
            child: const Icon(Icons.account_balance),
          ),
          AppSpacing.verticalSm,
          FloatingActionButton(
            heroTag: 'addTransaction',
            onPressed: () => Get.toNamed(AppRoutes.addTransaction),
            tooltip: 'Add Transaction',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Logout', style: AppTextStyles.h4),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.put(AuthController()).logout();
            },
            child: Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
