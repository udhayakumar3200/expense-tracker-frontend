import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/account_model.dart';
import '../models/transaction_model.dart';
import '../repositories/account_repository.dart';
import '../repositories/transaction_repository.dart';
// ignore: unused_import
import 'dashboard_controller.dart';

class TransactionController extends GetxController {
  final TransactionRepository _transactionRepository = TransactionRepository();
  final AccountRepository _accountRepository = AccountRepository();

  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final RxList<AccountModel> accounts = <AccountModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;

  final RxString selectedTransactionType = 'expense'.obs;
  final Rxn<int> selectedFromAccountId = Rxn<int>();
  final Rxn<int> selectedToAccountId = Rxn<int>();
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final List<Map<String, String>> transactionTypes = [
    {'value': 'expense', 'label': 'Expense'},
    {'value': 'income', 'label': 'Income'},
    {'value': 'transfer', 'label': 'Transfer'},
  ];

  @override
  void onInit() {
    super.onInit();
    // TODO: Uncomment for production
    // fetchAccounts();
    // fetchTransactions();

    // Mock data for UI preview
    _loadMockData();
  }

  void _loadMockData() {
    accounts.value = [
      AccountModel(id: 1, name: 'Main Savings', accountType: 'bank', balance: 5000.0, userId: 1),
      AccountModel(id: 2, name: 'Cash Wallet', accountType: 'cash', balance: 500.0, userId: 1),
      AccountModel(id: 3, name: 'GPay', accountType: 'upi', balance: 1200.0, userId: 1),
    ];
    selectedFromAccountId.value = accounts.first.id;

    transactions.value = [
      TransactionModel(id: 1, transactionType: 'expense', amount: 50.0, fromAccountId: 1, category: 'Food', description: 'Lunch', transactionDate: DateTime.now(), userId: 1),
      TransactionModel(id: 2, transactionType: 'income', amount: 3000.0, fromAccountId: 1, category: 'Salary', description: 'Monthly salary', transactionDate: DateTime.now().subtract(const Duration(days: 1)), userId: 1),
      TransactionModel(id: 3, transactionType: 'transfer', amount: 200.0, fromAccountId: 1, toAccountId: 2, description: 'Cash withdrawal', transactionDate: DateTime.now().subtract(const Duration(days: 2)), userId: 1),
    ];
  }

  @override
  void onClose() {
    amountController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> fetchAccounts() async {
    final response = await _accountRepository.getAccounts();
    if (response.success && response.data != null) {
      accounts.value = response.data!;
      if (accounts.isNotEmpty && selectedFromAccountId.value == null) {
        selectedFromAccountId.value = accounts.first.id;
      }
    }
  }

  Future<void> fetchTransactions() async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await _transactionRepository.getTransactions();

    isLoading.value = false;

    if (response.success && response.data != null) {
      transactions.value = response.data!;
    } else {
      errorMessage.value = response.message ?? 'Failed to fetch transactions';
    }
  }

  void clearFields() {
    amountController.clear();
    categoryController.clear();
    descriptionController.clear();
    selectedTransactionType.value = 'expense';
    selectedFromAccountId.value = accounts.isNotEmpty ? accounts.first.id : null;
    selectedToAccountId.value = null;
    selectedDate.value = DateTime.now();
    errorMessage.value = '';
  }

  Future<void> createTransaction() async {
    // TODO: Uncomment validation for production
    // if (!_validateFields()) return;

    // isSubmitting.value = true;
    // errorMessage.value = '';

    // final amount = double.tryParse(amountController.text.trim()) ?? 0;

    // final response = await _transactionRepository.createTransaction(
    //   transactionType: selectedTransactionType.value,
    //   amount: amount,
    //   fromAccountId: selectedFromAccountId.value!,
    //   toAccountId: selectedTransactionType.value == 'transfer'
    //       ? selectedToAccountId.value
    //       : null,
    //   category: categoryController.text.trim().isEmpty
    //       ? null
    //       : categoryController.text.trim(),
    //   description: descriptionController.text.trim().isEmpty
    //       ? null
    //       : descriptionController.text.trim(),
    //   transactionDate: selectedDate.value,
    // );

    // isSubmitting.value = false;

    // if (response.success) {
    //   Get.snackbar(
    //     'Success',
    //     'Transaction created successfully!',
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.green,
    //     colorText: Colors.white,
    //   );

    //   if (Get.isRegistered<DashboardController>()) {
    //     Get.find<DashboardController>().refreshData();
    //   }

    //   clearFields();
    //   Get.back();
    // } else {
    //   errorMessage.value = response.message ?? 'Failed to create transaction';
    // }

    // Skip validation for UI preview
    Get.snackbar(
      'Success',
      'Transaction created successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    clearFields();
    Get.back();
  }

  Future<void> refreshTransactions() async {
    await fetchTransactions();
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  // ignore: unused_element
  bool _validateFields() {
    if (amountController.text.trim().isEmpty) {
      errorMessage.value = 'Amount is required';
      return false;
    }

    final amount = double.tryParse(amountController.text.trim());
    if (amount == null || amount <= 0) {
      errorMessage.value = 'Please enter a valid amount greater than 0';
      return false;
    }

    if (selectedFromAccountId.value == null) {
      errorMessage.value = 'Please select an account';
      return false;
    }

    if (selectedTransactionType.value == 'transfer') {
      if (selectedToAccountId.value == null) {
        errorMessage.value = 'Please select a destination account for transfer';
        return false;
      }
      if (selectedFromAccountId.value == selectedToAccountId.value) {
        errorMessage.value = 'Source and destination accounts must be different';
        return false;
      }
    }

    return true;
  }

  String getAccountName(int accountId) {
    final account = accounts.firstWhereOrNull((a) => a.id == accountId);
    return account?.name ?? 'Unknown';
  }
}
