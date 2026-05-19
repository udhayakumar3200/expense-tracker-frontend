import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/account_model.dart';
import '../repositories/account_repository.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';
import 'custom_dropdown.dart';
import 'error_text.dart';

class AccountFormSheet extends StatefulWidget {
  final AccountModel account;

  const AccountFormSheet({super.key, required this.account});

  static void show(AccountModel account) {
    Get.bottomSheet(
      AccountFormSheet(account: account),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  State<AccountFormSheet> createState() => _AccountFormSheetState();
}

class _AccountFormSheetState extends State<AccountFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late String _selectedType;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.account.name);
    _balanceController = TextEditingController(
        text: widget.account.currentBalance.toStringAsFixed(2));
    _selectedType = widget.account.type.apiValue;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final balanceText = _balanceController.text.trim();

    if (name.isEmpty) {
      setState(() => _errorMessage = 'Account name is required');
      return;
    }
    if (balanceText.isEmpty || double.tryParse(balanceText) == null) {
      setState(() => _errorMessage = 'Please enter a valid balance');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final repo = AccountRepository();
    final response = await repo.updateAccount(
      widget.account.id,
      AccountUpdateRequest(
        name: name,
        type: AccountTypeX.fromApi(_selectedType),
        currentBalance: double.parse(balanceText),
      ),
    );

    if (!mounted) return;

    if (response.success) {
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().refreshData();
      }
      Get.back();
      Get.snackbar(
        'Updated',
        'Account updated successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = response.message ?? 'Failed to update account';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      child: SingleChildScrollView(
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
            Text('Edit Account', style: AppTextStyles.h2),
            AppSpacing.verticalMd,
            CustomTextField(
              controller: _nameController,
              label: 'Account Name',
              hint: 'e.g. My Savings',
              prefixIcon: Icons.account_balance_wallet_outlined,
            ),
            AppSpacing.verticalMd,
            AccountTypeDropdown(
              value: _selectedType,
              onChanged: (v) =>
                  setState(() => _selectedType = v ?? _selectedType),
            ),
            AppSpacing.verticalMd,
            CustomAmountField(controller: _balanceController),
            if (_errorMessage.isNotEmpty) ...[
              AppSpacing.verticalSm,
              ErrorText(message: _errorMessage),
            ],
            AppSpacing.verticalLg,
            CustomButton(
              text: 'Save Changes',
              onPressed: _isLoading ? null : _submit,
              isLoading: _isLoading,
            ),
            AppSpacing.verticalMd,
          ],
        ),
      ),
    );
  }
}
