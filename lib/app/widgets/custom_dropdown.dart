import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final String? errorText;

  const CustomDropdown({
    super.key,
    this.value,
    this.label,
    this.hint,
    this.prefixIcon,
    required this.items,
    this.onChanged,
    this.enabled = true,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.textSecondary)
            : null,
      ),
      dropdownColor: AppColors.cardBackground,
      borderRadius: AppSpacing.borderRadiusSm,
      isExpanded: true,
    );
  }
}

class AccountTypeDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? errorText;

  const AccountTypeDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.errorText,
  });

  static const List<Map<String, String>> accountTypes = [
    {'value': 'bank', 'label': 'Bank Account'},
    {'value': 'cash', 'label': 'Cash'},
    {'value': 'upi', 'label': 'UPI'},
    {'value': 'credit_card', 'label': 'Credit Card'},
  ];

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      value: value,
      label: 'Account Type',
      prefixIcon: Icons.category_outlined,
      errorText: errorText,
      items: accountTypes
          .map((type) => DropdownMenuItem(
                value: type['value'],
                child: Text(type['label']!),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class TransactionTypeDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? errorText;

  const TransactionTypeDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.errorText,
  });

  static const List<Map<String, String>> transactionTypes = [
    {'value': 'expense', 'label': 'Expense'},
    {'value': 'income', 'label': 'Income'},
    {'value': 'transfer', 'label': 'Transfer'},
  ];

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      value: value,
      label: 'Transaction Type',
      prefixIcon: Icons.swap_vert,
      errorText: errorText,
      items: transactionTypes
          .map((type) => DropdownMenuItem(
                value: type['value'],
                child: Text(type['label']!),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class AccountDropdown extends StatelessWidget {
  final String? value;
  final String? label;
  final List<Map<String, dynamic>> accounts;
  final ValueChanged<String?>? onChanged;
  final String? errorText;

  const AccountDropdown({
    super.key,
    this.value,
    this.label = 'Account',
    required this.accounts,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      value: value,
      label: label,
      prefixIcon: Icons.account_balance,
      errorText: errorText,
      items: accounts
          .map((account) => DropdownMenuItem<String>(
                value: account['id'].toString(),
                child: Text('${account['name']} (${account['type']})'),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class CategoryDropdown extends StatelessWidget {
  final String? value;
  final List<Map<String, dynamic>> categories;
  final ValueChanged<String?>? onChanged;
  final String? errorText;

  const CategoryDropdown({
    super.key,
    this.value,
    required this.categories,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      value: value,
      label: 'Category',
      prefixIcon: Icons.category_outlined,
      errorText: errorText,
      items: categories
          .map((category) => DropdownMenuItem<String>(
                value: category['id'].toString(),
                child: Text(category['name'].toString()),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
