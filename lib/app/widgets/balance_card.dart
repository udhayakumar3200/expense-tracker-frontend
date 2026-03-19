import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final String title;
  final String? subtitle;
  final List<Color>? gradientColors;
  final IconData? icon;

  const BalanceCard({
    super.key,
    required this.balance,
    this.title = 'Total Balance',
    this.subtitle,
    this.gradientColors,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final colors = gradientColors ?? AppColors.primaryGradient;

    return Card(
      elevation: AppSpacing.elevationMd,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Container(
        padding: AppSpacing.paddingLg,
        decoration: BoxDecoration(
          borderRadius: AppSpacing.borderRadiusMd,
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                  ),
                ),
                if (icon != null)
                  Icon(
                    icon,
                    color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                    size: AppSpacing.iconMd,
                  ),
              ],
            ),
            AppSpacing.verticalSm,
            Text(
              currencyFormat.format(balance),
              style: AppTextStyles.amount.copyWith(
                color: AppColors.textOnPrimary,
              ),
            ),
            if (subtitle != null) ...[
              AppSpacing.verticalXs,
              Text(
                subtitle!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MiniBalanceCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const MiniBalanceCard({
    super.key,
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              AppSpacing.horizontalXs,
              Text(
                label,
                style: AppTextStyles.caption.copyWith(color: color),
              ),
            ],
          ),
          AppSpacing.verticalXs,
          Text(
            currencyFormat.format(amount),
            style: AppTextStyles.bodyLargeBold.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
