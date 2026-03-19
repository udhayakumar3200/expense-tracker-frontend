import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

enum ButtonVariant { filled, outlined, text }
enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final bool iconAtEnd;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool fullWidth;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.variant = ButtonVariant.filled,
    this.size = ButtonSize.medium,
    this.icon,
    this.iconAtEnd = false,
    this.backgroundColor,
    this.foregroundColor,
    this.fullWidth = true,
  });

  double get _height {
    switch (size) {
      case ButtonSize.small:
        return AppSpacing.buttonHeightSm;
      case ButtonSize.medium:
        return AppSpacing.buttonHeightMd;
      case ButtonSize.large:
        return AppSpacing.buttonHeightLg;
    }
  }

  double get _fontSize {
    switch (size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isLoading && !isDisabled && onPressed != null;

    Widget child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == ButtonVariant.filled
                    ? AppColors.textOnPrimary
                    : AppColors.primary,
              ),
            ),
          )
        : _buildContent();

    final buttonStyle = _getButtonStyle();

    Widget button;
    switch (variant) {
      case ButtonVariant.filled:
        button = ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          child: child,
        );
        break;
      case ButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          child: child,
        );
        break;
      case ButtonVariant.text:
        button = TextButton(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          child: child,
        );
        break;
    }

    if (!fullWidth) {
      return button;
    }

    return SizedBox(
      width: double.infinity,
      height: _height,
      child: button,
    );
  }

  Widget _buildContent() {
    if (icon == null) {
      return Text(
        text,
        style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w600),
      );
    }

    final iconWidget = Icon(icon, size: _fontSize + 4);
    final textWidget = Text(
      text,
      style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w600),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: iconAtEnd
          ? [textWidget, AppSpacing.horizontalSm, iconWidget]
          : [iconWidget, AppSpacing.horizontalSm, textWidget],
    );
  }

  ButtonStyle _getButtonStyle() {
    final bgColor = backgroundColor ?? AppColors.primary;
    final fgColor = foregroundColor ??
        (variant == ButtonVariant.filled
            ? AppColors.textOnPrimary
            : AppColors.primary);

    switch (variant) {
      case ButtonVariant.filled:
        return ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          minimumSize: Size(0, _height),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusSm,
          ),
        );
      case ButtonVariant.outlined:
        return OutlinedButton.styleFrom(
          foregroundColor: fgColor,
          minimumSize: Size(0, _height),
          side: BorderSide(color: bgColor),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusSm,
          ),
        );
      case ButtonVariant.text:
        return TextButton.styleFrom(
          foregroundColor: fgColor,
          minimumSize: Size(0, _height),
        );
    }
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final String? tooltip;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = 24,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      icon: Icon(icon, size: size),
      onPressed: onPressed,
      color: color ?? AppColors.textSecondary,
      style: backgroundColor != null
          ? IconButton.styleFrom(backgroundColor: backgroundColor)
          : null,
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}
