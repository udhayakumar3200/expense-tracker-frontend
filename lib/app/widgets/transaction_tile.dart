import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final String? fromAccountName;
  final String? toAccountName;
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.fromAccountName,
    this.toAccountName,
    this.onTap,
  });

  IconData _getTypeIcon() {
    switch (transaction.transactionType) {
      case 'expense':
        return Icons.arrow_upward;
      case 'income':
        return Icons.arrow_downward;
      case 'transfer':
        return Icons.swap_horiz;
      default:
        return Icons.receipt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormat = DateFormat('MMM dd, yyyy');
    
    final isExpense = transaction.transactionType == 'expense';
    final isIncome = transaction.transactionType == 'income';
    final isTransfer = transaction.transactionType == 'transfer';

    final typeColor = AppColors.getTransactionColor(transaction.transactionType);
    final typeBgColor = AppColors.getTransactionLightColor(transaction.transactionType);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: typeBgColor,
          child: Icon(
            _getTypeIcon(),
            color: typeColor,
            size: AppSpacing.iconMd,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                transaction.category ?? transaction.displayType,
                style: AppTextStyles.bodyMediumBold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${isExpense ? '-' : isIncome ? '+' : ''}${currencyFormat.format(transaction.amount)}',
              style: AppTextStyles.bodyLargeBold.copyWith(color: typeColor),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (transaction.description != null &&
                transaction.description!.isNotEmpty) ...[
              AppSpacing.verticalXs,
              Text(
                transaction.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption,
              ),
            ],
            AppSpacing.verticalXs,
            Row(
              children: [
                Text(
                  dateFormat.format(transaction.transactionDate),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
                if (isTransfer && toAccountName != null) ...[
                  AppSpacing.horizontalSm,
                  Icon(
                    Icons.arrow_forward,
                    size: 12,
                    color: AppColors.textHint,
                  ),
                  AppSpacing.horizontalXs,
                  Expanded(
                    child: Text(
                      toAccountName!,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textHint,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        isThreeLine: transaction.description != null &&
            transaction.description!.isNotEmpty,
      ),
    );
  }
}

class TransactionTileSimple extends StatelessWidget {
  final String type;
  final double amount;
  final String? category;
  final String? description;
  final DateTime date;
  final String? toAccountName;
  final VoidCallback? onTap;

  const TransactionTileSimple({
    super.key,
    required this.type,
    required this.amount,
    this.category,
    this.description,
    required this.date,
    this.toAccountName,
    this.onTap,
  });

  IconData _getTypeIcon() {
    switch (type) {
      case 'expense':
        return Icons.arrow_upward;
      case 'income':
        return Icons.arrow_downward;
      case 'transfer':
        return Icons.swap_horiz;
      default:
        return Icons.receipt;
    }
  }

  String _getDisplayType() {
    switch (type) {
      case 'expense':
        return 'Expense';
      case 'income':
        return 'Income';
      case 'transfer':
        return 'Transfer';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormat = DateFormat('MMM dd, yyyy');
    
    final isExpense = type == 'expense';
    final isIncome = type == 'income';
    final isTransfer = type == 'transfer';

    final typeColor = AppColors.getTransactionColor(type);
    final typeBgColor = AppColors.getTransactionLightColor(type);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: typeBgColor,
          child: Icon(
            _getTypeIcon(),
            color: typeColor,
            size: AppSpacing.iconMd,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                category ?? _getDisplayType(),
                style: AppTextStyles.bodyMediumBold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${isExpense ? '-' : isIncome ? '+' : ''}${currencyFormat.format(amount)}',
              style: AppTextStyles.bodyLargeBold.copyWith(color: typeColor),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (description != null && description!.isNotEmpty) ...[
              AppSpacing.verticalXs,
              Text(
                description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption,
              ),
            ],
            AppSpacing.verticalXs,
            Row(
              children: [
                Text(
                  dateFormat.format(date),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
                if (isTransfer && toAccountName != null) ...[
                  AppSpacing.horizontalSm,
                  Icon(
                    Icons.arrow_forward,
                    size: 12,
                    color: AppColors.textHint,
                  ),
                  AppSpacing.horizontalXs,
                  Expanded(
                    child: Text(
                      toAccountName!,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textHint,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        isThreeLine: description != null && description!.isNotEmpty,
      ),
    );
  }
}
