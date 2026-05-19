import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/transaction_controller.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/transaction_model.dart';
import '../repositories/transaction_repository.dart';
import 'delete_confirm_dialog.dart';
import 'transaction_form_sheet.dart';

class TransactionDetailSheet extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailSheet({super.key, required this.transaction});

  static void show(TransactionModel transaction) {
    Get.bottomSheet(
      TransactionDetailSheet(transaction: transaction),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _deleteTransaction() async {
    final repo = TransactionRepository();
    final response = await repo.deleteTransaction(transaction.id);
    if (response.success) {
      if (Get.isRegistered<TransactionController>()) {
        Get.find<TransactionController>().fetchTransactions();
      }
      Get.snackbar(
        'Deleted',
        'Transaction has been deleted.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        response.message ?? 'Failed to delete transaction',
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
    final dateFormat = DateFormat('MMM dd, yyyy');
    final typeColor =
        AppColors.getTransactionColor(transaction.transactionType);

    final isExpense = transaction.type == TransactionType.expense;
    final isIncome = transaction.type == TransactionType.income;
    final amountPrefix = isExpense ? '-' : isIncome ? '+' : '';

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
          Text(
            '$amountPrefix${currencyFormat.format(transaction.amount)}',
            style: AppTextStyles.h2.copyWith(color: typeColor),
          ),
          AppSpacing.verticalXs,
          Text(transaction.displayType, style: AppTextStyles.caption),
          AppSpacing.verticalMd,
          _InfoRow('Date', dateFormat.format(transaction.transactionDate)),
          if (transaction.description != null &&
              transaction.description!.isNotEmpty)
            _InfoRow('Description', transaction.description!),
          AppSpacing.verticalLg,
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit'),
                  onPressed: () {
                    Get.back();
                    TransactionFormSheet.show(transaction);
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
                      itemName:
                          transaction.description ?? transaction.displayType,
                      itemType: 'Transaction',
                      onConfirm: _deleteTransaction,
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label,
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.textSecondary)),
          ),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}
