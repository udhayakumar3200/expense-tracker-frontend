import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/dashboard_controller.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/account_model.dart';
import '../repositories/account_repository.dart';
import 'account_form_sheet.dart';
import 'delete_confirm_dialog.dart';

class AccountDetailSheet extends StatelessWidget {
  final AccountModel account;

  const AccountDetailSheet({super.key, required this.account});

  static void show(AccountModel account) {
    Get.bottomSheet(
      AccountDetailSheet(account: account),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _deleteAccount() async {
    final repo = AccountRepository();
    final response = await repo.deleteAccount(account.id);
    if (response.success) {
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().refreshData();
      }
      Get.snackbar(
        'Deleted',
        '"${account.name}" has been deleted.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        response.message ?? 'Failed to delete account',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      padding: AppSpacing.screenPadding.copyWith(
        bottom: AppSpacing.screenPadding.bottom +
            MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.textHint,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(account.name, style: AppTextStyles.h2),
          AppSpacing.verticalSm,
          Text(account.displayType, style: AppTextStyles.caption),
          AppSpacing.verticalMd,
          Row(
            children: [
              Text('Balance: ', style: AppTextStyles.bodyMedium),
              Text(
                currencyFormat.format(account.currentBalance),
                style: AppTextStyles.bodyLargeBold.copyWith(
                  color: account.currentBalance >= 0
                      ? AppColors.income
                      : AppColors.expense,
                ),
              ),
            ],
          ),
          AppSpacing.verticalLg,
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit'),
                  onPressed: () {
                    Get.back();
                    AccountFormSheet.show(account);
                  },
                ),
              ),
              AppSpacing.horizontalMd,
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.delete_outline, color: AppColors.error),
                  label: Text('Delete',
                      style: TextStyle(color: AppColors.error)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.error),
                  ),
                  onPressed: () {
                    Get.back();
                    DeleteConfirmDialog.show(
                      itemName: account.name,
                      itemType: 'Account',
                      onConfirm: _deleteAccount,
                    );
                  },
                ),
              ),
            ],
          ),
          AppSpacing.verticalMd,
        ],
      ),
    );
  }
}
