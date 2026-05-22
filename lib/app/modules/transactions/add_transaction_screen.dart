import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/transaction_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/account_model.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/error_text.dart';
import '../../widgets/empty_state.dart';

class AddTransactionScreen extends GetView<TransactionController> {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Obx(() {
        if (controller.accounts.isEmpty) {
          return EmptyState(
            icon: Icons.account_balance_wallet_outlined,
            title: 'No accounts available',
            subtitle: 'Please create an account first',
            buttonText: 'Go Back',
            onButtonPressed: () => Get.back(),
          );
        }

        return SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TransactionTypeDropdown(
                value: controller.selectedTransactionType.value,
                isCreditCardContext: controller.isCreditCardContext,
                onChanged: (value) {
                  if (value != null) {
                    final prevFromId = controller.selectedFromAccountId.value;
                    final prevToId = controller.selectedToAccountId.value;
                    final isFromCC = controller.accountById(prevFromId)?.isCreditCard ?? false;
                    final isToCC = controller.accountById(prevToId)?.isCreditCard ?? false;

                    controller.selectedTransactionType.value = value;
                    controller.selectedCategoryId.value = null;

                    if (isFromCC && value == 'transfer') {
                      // Credit Expense → Card Repayment: CC moves to "to", clear "from"
                      controller.selectedToAccountId.value = prevFromId;
                      controller.selectedFromAccountId.value = null;
                    } else if (isToCC && value == 'expense') {
                      // Card Repayment → Credit Expense: CC moves back to "from"
                      controller.selectedFromAccountId.value = prevToId;
                      controller.selectedToAccountId.value = null;
                    } else {
                      controller.selectedFromAccountId.value = null;
                      controller.selectedToAccountId.value = null;
                    }
                  }
                },
              ),
              AppSpacing.verticalMd,
              CustomAmountField(
                controller: controller.amountController,
              ),
              AppSpacing.verticalMd,
              if (controller.selectedTransactionType.value == 'expense' ||
                  controller.selectedTransactionType.value == 'transfer') ...[
                CustomDropdown<String>(
                  value: controller.selectedFromAccountId.value,
                  label: 'From Account',
                  prefixIcon: Icons.account_balance,
                  items: controller.accounts
                      .map((account) => DropdownMenuItem(
                            value: account.id,
                            child: Text(_accountDropdownLabel(account, isFrom: true)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.selectedFromAccountId.value = value;
                    final newAcc = controller.accountById(value);
                    if (newAcc?.isCreditCard == true &&
                        controller.selectedTransactionType.value == 'income') {
                      controller.selectedTransactionType.value = 'expense';
                      controller.selectedToAccountId.value = null;
                      controller.selectedCategoryId.value = null;
                    }
                  },
                ),
                _CreditCardCaption(
                  account: controller.accountById(
                      controller.selectedFromAccountId.value),
                  isFrom: true,
                ),
              ],
              if (controller.selectedTransactionType.value == 'income' ||
                  controller.selectedTransactionType.value == 'transfer') ...[
                AppSpacing.verticalMd,
                CustomDropdown<String>(
                  value: controller.selectedToAccountId.value,
                  label: 'To Account',
                  prefixIcon: Icons.account_balance,
                  items: controller.accounts
                      .where((a) =>
                          controller.selectedTransactionType.value != 'transfer' ||
                          a.id != controller.selectedFromAccountId.value)
                      .map((account) => DropdownMenuItem(
                            value: account.id,
                            child: Text(_accountDropdownLabel(account, isFrom: false)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.selectedToAccountId.value = value;
                  },
                ),
                _CreditCardCaption(
                  account: controller.accountById(
                      controller.selectedToAccountId.value),
                  isFrom: false,
                ),
              ],
              if (controller.selectedTransactionType.value != 'transfer') ...[
                AppSpacing.verticalMd,
                CategoryDropdown(
                  value: controller.selectedCategoryId.value,
                  categories: controller.categoriesForSelectedType
                      .map((c) => {'id': c.id, 'name': c.name})
                      .toList(),
                  onChanged: (value) => controller.selectedCategoryId.value = value,
                ),
              ],
              AppSpacing.verticalMd,
              CustomTextField(
                controller: controller.descriptionController,
                label: 'Description (Optional)',
                hint: 'Add a note',
                prefixIcon: Icons.notes,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
              ),
              AppSpacing.verticalMd,
              _DatePickerField(
                selectedDate: controller.selectedDate.value,
                dateFormat: dateFormat,
                onTap: () => controller.selectDate(context),
              ),
              AppSpacing.verticalSm,
              ErrorText(
                message: controller.errorMessage.value,
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              ),
              AppSpacing.verticalLg,
              CustomButton(
                text: 'Create Transaction',
                onPressed: controller.createTransaction,
                isLoading: controller.isSubmitting.value,
              ),
            ],
          ),
        );
      }),
    );
  }
}

String _accountDropdownLabel(AccountModel account, {required bool isFrom}) {
  final base = '${account.name} (${account.displayType})';
  if (!account.isCreditCard) return base;
  final currency = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  if (isFrom) {
    return '$base · Avail ${currency.format(account.availableCredit)}';
  }
  return '$base · Outstanding ${currency.format(account.outstandingBalance ?? 0)}';
}

class _CreditCardCaption extends StatelessWidget {
  final AccountModel? account;
  final bool isFrom;

  const _CreditCardCaption({required this.account, required this.isFrom});

  @override
  Widget build(BuildContext context) {
    final acc = account;
    if (acc == null || !acc.isCreditCard) {
      return const SizedBox.shrink();
    }
    final currency = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final label = isFrom
        ? 'Available credit: ${currency.format(acc.availableCredit)}'
        : 'Outstanding: ${currency.format(acc.outstandingBalance ?? 0)}';
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs, left: AppSpacing.sm),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final DateTime selectedDate;
  final DateFormat dateFormat;
  final VoidCallback onTap;

  const _DatePickerField({
    required this.selectedDate,
    required this.dateFormat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusSm,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date',
          prefixIcon: Icon(
            Icons.calendar_today,
            color: AppColors.textSecondary,
          ),
        ),
        child: Text(
          dateFormat.format(selectedDate),
          style: AppTextStyles.bodyMedium,
        ),
      ),
    );
  }
}
