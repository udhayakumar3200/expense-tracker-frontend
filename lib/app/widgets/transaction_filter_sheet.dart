import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/transaction_controller.dart';
import '../models/category_model.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'custom_button.dart';
import 'custom_dropdown.dart';

class TransactionFilterSheet extends StatefulWidget {
  const TransactionFilterSheet({super.key});

  static void show() {
    Get.bottomSheet(
      const TransactionFilterSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  State<TransactionFilterSheet> createState() =>
      _TransactionFilterSheetState();
}

class _TransactionFilterSheetState extends State<TransactionFilterSheet> {
  late String? _selectedType;
  late String? _selectedFromAccountId;
  late String? _selectedCategoryId;
  late DateTime? _dateFrom;
  late DateTime? _dateTo;

  TransactionController get _ctrl => Get.find<TransactionController>();

  @override
  void initState() {
    super.initState();
    _selectedType = _ctrl.filterType.value;
    _selectedFromAccountId = _ctrl.filterFromAccountId.value;
    _selectedCategoryId = _ctrl.filterCategoryId.value;
    _dateFrom = _ctrl.filterDateFrom.value;
    _dateTo = _ctrl.filterDateTo.value;
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (isFrom ? _dateFrom : _dateTo) ?? now,
      firstDate: DateTime(2020),
      lastDate: now.add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _dateFrom = picked;
        } else {
          _dateTo = picked;
        }
      });
    }
  }

  void _apply() {
    _ctrl.applyFilters(
      type: _selectedType,
      fromAccountId: _selectedFromAccountId,
      categoryId: _selectedCategoryId,
      dateFrom: _dateFrom,
      dateTo: _dateTo,
    );
    Get.back();
  }

  void _clear() {
    _ctrl.clearFilters();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final accountItems = _ctrl.accounts
        .map((a) => <String, dynamic>{
              'id': a.id,
              'name': a.name,
              'type': a.displayType,
            })
        .toList();
    final categoryItems = _ctrl.categories
        .where((c) =>
            _selectedType == null || c.type.apiValue == _selectedType)
        .map((c) => <String, dynamic>{'id': c.id, 'name': c.name})
        .toList();

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
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            Text('Filter Transactions', style: AppTextStyles.h2),
            AppSpacing.verticalMd,
            CustomDropdown<String>(
              value: _selectedType,
              label: 'Type',
              prefixIcon: Icons.swap_vert,
              items: [
                const DropdownMenuItem(
                    value: null, child: Text('All types')),
                ...['expense', 'income', 'transfer'].map((t) =>
                    DropdownMenuItem(
                        value: t,
                        child: Text(
                            t[0].toUpperCase() + t.substring(1)))),
              ],
              onChanged: (v) => setState(() {
                _selectedType = v;
                _selectedCategoryId = null;
              }),
            ),
            AppSpacing.verticalMd,
            if (accountItems.isNotEmpty) ...[
              AccountDropdown(
                value: _selectedFromAccountId,
                label: 'Account',
                accounts: accountItems,
                onChanged: (v) =>
                    setState(() => _selectedFromAccountId = v),
              ),
              AppSpacing.verticalMd,
            ],
            if (categoryItems.isNotEmpty &&
                _selectedType != 'transfer') ...[
              CategoryDropdown(
                value: _selectedCategoryId,
                categories: categoryItems,
                onChanged: (v) =>
                    setState(() => _selectedCategoryId = v),
              ),
              AppSpacing.verticalMd,
            ],
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today_outlined,
                        size: 16),
                    label: Text(_dateFrom != null
                        ? dateFormat.format(_dateFrom!)
                        : 'From date'),
                    onPressed: () => _pickDate(isFrom: true),
                  ),
                ),
                AppSpacing.horizontalSm,
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today_outlined,
                        size: 16),
                    label: Text(_dateTo != null
                        ? dateFormat.format(_dateTo!)
                        : 'To date'),
                    onPressed: () => _pickDate(isFrom: false),
                  ),
                ),
              ],
            ),
            AppSpacing.verticalLg,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Clear',
                    variant: ButtonVariant.outlined,
                    onPressed: _clear,
                  ),
                ),
                AppSpacing.horizontalMd,
                Expanded(
                  child: CustomButton(
                    text: 'Apply Filters',
                    onPressed: _apply,
                  ),
                ),
              ],
            ),
            AppSpacing.verticalMd,
          ],
        ),
      ),
    );
  }
}
