import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/error_text.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: AppSpacing.iconXxl,
                  color: AppColors.primary,
                ),
                AppSpacing.verticalMd,
                Text(
                  'Expense Tracker',
                  style: AppTextStyles.h2,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.verticalSm,
                Obx(() => Text(
                      controller.isLoginMode.value
                          ? 'Welcome back!'
                          : 'Create your account',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    )),
                AppSpacing.verticalXl,
                Obx(() {
                  if (!controller.isLoginMode.value) {
                    return Column(
                      children: [
                        CustomTextField(
                          controller: controller.nameController,
                          label: 'Name (Optional)',
                          prefixIcon: Icons.person_outline,
                          textCapitalization: TextCapitalization.words,
                        ),
                        AppSpacing.verticalMd,
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),
                CustomEmailField(
                  controller: controller.emailController,
                ),
                AppSpacing.verticalMd,
                CustomPasswordField(
                  controller: controller.passwordController,
                  onSubmitted: (_) {
                    if (controller.isLoginMode.value) {
                      controller.login();
                    } else {
                      controller.register();
                    }
                  },
                ),
                AppSpacing.verticalSm,
                Obx(() => ErrorText(
                      message: controller.errorMessage.value,
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    )),
                AppSpacing.verticalMd,
                Obx(() => CustomButton(
                      text: controller.isLoginMode.value ? 'Login' : 'Register',
                      onPressed: () {
                        if (controller.isLoginMode.value) {
                          controller.login();
                        } else {
                          controller.register();
                        }
                      },
                      isLoading: controller.isLoading.value,
                    )),
                AppSpacing.verticalMd,
                Obx(() => CustomButton(
                      text: controller.isLoginMode.value
                          ? "Don't have an account? Register"
                          : 'Already have an account? Login',
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.toggleMode,
                      variant: ButtonVariant.text,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
