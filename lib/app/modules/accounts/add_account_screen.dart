import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/account_controller.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/error_text.dart';

class AddAccountScreen extends GetView<AccountController> {
  const AddAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: controller.nameController,
              label: 'Account Name',
              hint: 'e.g., Savings Account',
              prefixIcon: Icons.account_balance_wallet_outlined,
              textCapitalization: TextCapitalization.words,
            ),
            AppSpacing.verticalMd,
            Obx(() => AccountTypeDropdown(
                  value: controller.selectedAccountType.value,
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedAccountType.value = value;
                    }
                  },
                )),
            AppSpacing.verticalMd,
            CustomAmountField(
              controller: controller.balanceController,
              label: 'Initial Balance',
              onSubmitted: (_) => controller.createAccount(),
            ),
            AppSpacing.verticalSm,
            Obx(() => ErrorText(
                  message: controller.errorMessage.value,
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                )),
            AppSpacing.verticalLg,
            Obx(() => CustomButton(
                  text: 'Create Account',
                  onPressed: controller.createAccount,
                  isLoading: controller.isLoading.value,
                )),
          ],
        ),
      ),
    );
  }
}
