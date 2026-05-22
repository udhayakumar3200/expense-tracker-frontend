import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/transaction_controller.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../repositories/transaction_repository.dart';
import 'custom_button.dart';
import 'custom_dropdown.dart';
import 'custom_text_field.dart';
import 'error_text.dart';

class TransactionFormSheet extends StatefulWidget {
  final TransactionModel transaction;

  const TransactionFormSheet({super.key, required this.transaction});

  static void show(TransactionModel transaction) {
    Get.bottomSheet(
      TransactionFormSheet(transaction: transaction),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  State<TransactionFormSheet> createState() => _TransactionFormSheetState();
}

class _TransactionFormSheetState extends State<TransactionFormSheet> {
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late String _selectedType;
  late String? _selectedFromAccountId;
  late String? _selectedToAccountId;
  late String? _selectedCategoryId;
  late DateTime _selectedDate;
  bool _isLoading = false;
  String _errorMessage = '';

  TransactionController get _ctrl => Get.find<TransactionController>();

  @override
  void initState() {
    super.initState();
    final t = widget.transaction;
    _amountController =
        TextEditingController(text: t.amount.toStringAsFixed(2));
    _descriptionController =
        TextEditingController(text: t.description ?? '');
    _selectedType = t.type.apiValue;
    _selectedFromAccountId = t.fromAccountId;
    _selectedToAccountId = t.toAccountId;
    _selectedCategoryId = t.categoryId;
    _selectedDate = t.transactionDate;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    final amountText = _amountController.text.trim();
    final amount = double.tryParse(amountText);

    final error = TransactionController.validateTransaction(
      type: _selectedType,
      amountText: amountText,
      fromAccountId: _selectedFromAccountId,
      toAccountId: _selectedToAccountId,
      accounts: _ctrl.accounts,
    );
    if (error != null) {
      setState(() => _errorMessage = error);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final repo = TransactionRepository();
    final response = await repo.updateTransaction(
      widget.transaction.id,
      TransactionUpdateRequest(
        amount: amount,
        type: TransactionTypeX.fromApi(_selectedType),
        transactionDate: _selectedDate,
        fromAccountId: _selectedFromAccountId,
        toAccountId: _selectedToAccountId,
        categoryId: _selectedCategoryId,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      ),
    );

    if (!mounted) return;

    if (response.success) {
      if (Get.isRegistered<TransactionController>()) {
        Get.find<TransactionController>().fetchTransactions();
      }
      Get.back();
      Get.snackbar(
        'Updated',
        'Transaction updated successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = response.message ?? 'Failed to update transaction';
      });
    }
  }

  List<DropdownMenuItem<String>> _accountDropdownItems({
    required bool isFrom,
    String? excludeId,
  }) {
    final currency = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return _ctrl.accounts
        .where((a) => excludeId == null || a.id != excludeId)
        .map((a) {
      var label = '${a.name} (${a.displayType})';
      if (a.isCreditCard) {
        label += isFrom
            ? ' · Avail ${currency.format(a.availableCredit)}'
            : ' · Outstanding ${currency.format(a.outstandingBalance ?? 0)}';
      }
      return DropdownMenuItem<String>(value: a.id, child: Text(label));
    }).toList();
  }

  Widget _ccCaption(String? accountId, {required bool isFrom}) {
    final acc = _ctrl.accountById(accountId);
    if (acc == null || !acc.isCreditCard) return const SizedBox.shrink();
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

  bool get _isCreditCardContext {
    final fromAcc = _ctrl.accountById(_selectedFromAccountId);
    if (fromAcc?.isCreditCard == true) return true;
    if (_selectedType == 'transfer') {
      final toAcc = _ctrl.accountById(_selectedToAccountId);
      return toAcc?.isCreditCard == true;
    }
    return false;
  }

  List<Map<String, dynamic>> get _categoryItems {
    if (_selectedType == 'transfer') return [];
    return _ctrl.categories
        .where((c) => c.type.apiValue == _selectedType)
        .map((c) => <String, dynamic>{'id': c.id, 'name': c.name})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

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
            Text('Edit Transaction', style: AppTextStyles.h2),
            AppSpacing.verticalMd,
            TransactionTypeDropdown(
              value: _selectedType,
              isCreditCardContext: _isCreditCardContext,
              onChanged: (v) {
                if (v == null) return;
                setState(() {
                  final prevFromId = _selectedFromAccountId;
                  final prevToId = _selectedToAccountId;
                  final isFromCC = _ctrl.accountById(prevFromId)?.isCreditCard ?? false;
                  final isToCC = _ctrl.accountById(prevToId)?.isCreditCard ?? false;

                  _selectedType = v;
                  _selectedCategoryId = null;

                  if (isFromCC && v == 'transfer') {
                    _selectedToAccountId = prevFromId;
                    _selectedFromAccountId = null;
                  } else if (isToCC && v == 'expense') {
                    _selectedFromAccountId = prevToId;
                    _selectedToAccountId = null;
                  }
                });
              },
            ),
            AppSpacing.verticalMd,
            CustomAmountField(controller: _amountController),
            AppSpacing.verticalMd,
            if (_selectedType == 'expense' || _selectedType == 'transfer') ...[
              CustomDropdown<String>(
                value: _selectedFromAccountId,
                label: 'From Account',
                prefixIcon: Icons.account_balance,
                items: _accountDropdownItems(isFrom: true),
                onChanged: (v) =>
                    setState(() => _selectedFromAccountId = v),
              ),
              _ccCaption(_selectedFromAccountId, isFrom: true),
              AppSpacing.verticalMd,
            ],
            if (_selectedType == 'income' || _selectedType == 'transfer') ...[
              CustomDropdown<String>(
                value: _selectedToAccountId,
                label: 'To Account',
                prefixIcon: Icons.account_balance,
                items: _accountDropdownItems(
                  isFrom: false,
                  excludeId: _selectedType == 'transfer'
                      ? _selectedFromAccountId
                      : null,
                ),
                onChanged: (v) => setState(() => _selectedToAccountId = v),
              ),
              _ccCaption(_selectedToAccountId, isFrom: false),
              AppSpacing.verticalMd,
            ],
            if (_selectedType != 'transfer' && _categoryItems.isNotEmpty) ...[
              CategoryDropdown(
                value: _selectedCategoryId,
                categories: _categoryItems,
                onChanged: (v) =>
                    setState(() => _selectedCategoryId = v),
              ),
              AppSpacing.verticalMd,
            ],
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text(dateFormat.format(_selectedDate)),
              onPressed: _pickDate,
            ),
            AppSpacing.verticalMd,
            CustomTextField(
              controller: _descriptionController,
              label: 'Description (optional)',
              hint: 'Add a note',
              prefixIcon: Icons.notes,
            ),
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
