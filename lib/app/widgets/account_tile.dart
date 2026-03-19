import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/account_model.dart';

class AccountTile extends StatelessWidget {
  final AccountModel account;
  final VoidCallback? onTap;
  final bool showBalance;

  const AccountTile({
    super.key,
    required this.account,
    this.onTap,
    this.showBalance = true,
  });

  IconData _getAccountIcon() {
    switch (account.accountType) {
      case 'bank':
        return Icons.account_balance;
      case 'cash':
        return Icons.payments;
      case 'upi':
        return Icons.phone_android;
      case 'credit_card':
        return Icons.credit_card;
      default:
        return Icons.account_balance_wallet;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final iconColor = AppColors.getAccountColor(account.accountType);
    final iconBgColor = AppColors.getAccountLightColor(account.accountType);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: iconBgColor,
          child: Icon(
            _getAccountIcon(),
            color: iconColor,
            size: AppSpacing.iconMd,
          ),
        ),
        title: Text(
          account.name,
          style: AppTextStyles.bodyMediumBold,
        ),
        subtitle: Text(
          account.displayType,
          style: AppTextStyles.caption,
        ),
        trailing: showBalance
            ? Text(
                currencyFormat.format(account.balance),
                style: AppTextStyles.bodyLargeBold.copyWith(
                  color: account.balance >= 0
                      ? AppColors.income
                      : AppColors.expense,
                ),
              )
            : const Icon(Icons.chevron_right),
      ),
    );
  }
}

class AccountTileSimple extends StatelessWidget {
  final String name;
  final String type;
  final double balance;
  final VoidCallback? onTap;

  const AccountTileSimple({
    super.key,
    required this.name,
    required this.type,
    required this.balance,
    this.onTap,
  });

  IconData _getAccountIcon() {
    switch (type) {
      case 'bank':
        return Icons.account_balance;
      case 'cash':
        return Icons.payments;
      case 'upi':
        return Icons.phone_android;
      case 'credit_card':
        return Icons.credit_card;
      default:
        return Icons.account_balance_wallet;
    }
  }

  String _getDisplayType() {
    switch (type) {
      case 'bank':
        return 'Bank Account';
      case 'cash':
        return 'Cash';
      case 'upi':
        return 'UPI';
      case 'credit_card':
        return 'Credit Card';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final iconColor = AppColors.getAccountColor(type);
    final iconBgColor = AppColors.getAccountLightColor(type);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: iconBgColor,
          child: Icon(
            _getAccountIcon(),
            color: iconColor,
            size: AppSpacing.iconMd,
          ),
        ),
        title: Text(
          name,
          style: AppTextStyles.bodyMediumBold,
        ),
        subtitle: Text(
          _getDisplayType(),
          style: AppTextStyles.caption,
        ),
        trailing: Text(
          currencyFormat.format(balance),
          style: AppTextStyles.bodyLargeBold.copyWith(
            color: balance >= 0 ? AppColors.income : AppColors.expense,
          ),
        ),
      ),
    );
  }
}
