import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

class ErrorText extends StatelessWidget {
  final String? message;
  final TextAlign textAlign;
  final EdgeInsets padding;

  const ErrorText({
    super.key,
    this.message,
    this.textAlign = TextAlign.center,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding,
      child: Text(
        message!,
        style: AppTextStyles.error,
        textAlign: textAlign,
      ),
    );
  }
}

class ErrorContainer extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final String retryText;

  const ErrorContainer({
    super.key,
    this.message,
    this.onRetry,
    this.retryText = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: AppSpacing.iconMd,
          ),
          AppSpacing.horizontalSm,
          Expanded(
            child: Text(
              message!,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
          if (onRetry != null) ...[
            AppSpacing.horizontalSm,
            TextButton(
              onPressed: onRetry,
              child: Text(retryText),
            ),
          ],
        ],
      ),
    );
  }
}

class SuccessText extends StatelessWidget {
  final String? message;
  final TextAlign textAlign;
  final EdgeInsets padding;

  const SuccessText({
    super.key,
    this.message,
    this.textAlign = TextAlign.center,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding,
      child: Text(
        message!,
        style: AppTextStyles.success,
        textAlign: textAlign,
      ),
    );
  }
}
