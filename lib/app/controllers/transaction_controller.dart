import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/account_model.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../repositories/account_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/transaction_repository.dart';
import 'dashboard_controller.dart';

class TransactionController extends GetxController {
  final TransactionRepository _transactionRepository = TransactionRepository();
  final AccountRepository _accountRepository = AccountRepository();
  final CategoryRepository _categoryRepository = CategoryRepository();

  // Form fields for create
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  // Transaction list state
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final RxList<AccountModel> accounts = <AccountModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = false.obs;
  final RxString errorMessage = ''.obs;

  // Pagination
  static const int _pageSize = 20;
  int _currentOffset = 0;

  // Filter state
  final RxnString filterType = RxnString();
  final RxnString filterFromAccountId = RxnString();
  final RxnString filterCategoryId = RxnString();
  final Rx<DateTime?> filterDateFrom = Rx<DateTime?>(null);
  final Rx<DateTime?> filterDateTo = Rx<DateTime?>(null);

  // Form state for create
  final RxString selectedTransactionType = 'expense'.obs;
  final RxnString selectedFromAccountId = RxnString();
  final RxnString selectedToAccountId = RxnString();
  final RxnString selectedCategoryId = RxnString();
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final List<Map<String, String>> transactionTypes = [
    {'value': 'expense', 'label': 'Expense'},
    {'value': 'income', 'label': 'Income'},
    {'value': 'transfer', 'label': 'Transfer'},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchAccounts();
    fetchCategories();
    fetchTransactions();
  }

  @override
  void onClose() {
    amountController.dispose();
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

  Future<void> fetchCategories() async {
    final response = await _categoryRepository.getCategories();
    if (response.success && response.data != null) {
      categories.value = response.data!;
    }
  }

  Future<void> fetchTransactions() async {
    isLoading.value = true;
    errorMessage.value = '';
    _currentOffset = 0;

    final response = await _transactionRepository.getTransactions(
      limit: _pageSize,
      offset: 0,
      transactionType: filterType.value,
      fromAccountId: filterFromAccountId.value,
      categoryId: filterCategoryId.value,
      dateFrom: filterDateFrom.value,
      dateTo: filterDateTo.value,
    );

    isLoading.value = false;

    if (response.success && response.data != null) {
      transactions.value = response.data!;
      hasMore.value = response.data!.length == _pageSize;
      _currentOffset = response.data!.length;
    } else {
      errorMessage.value =
          response.message ?? 'Failed to fetch transactions';
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value) return;
    isLoadingMore.value = true;

    final response = await _transactionRepository.getTransactions(
      limit: _pageSize,
      offset: _currentOffset,
      transactionType: filterType.value,
      fromAccountId: filterFromAccountId.value,
      categoryId: filterCategoryId.value,
      dateFrom: filterDateFrom.value,
      dateTo: filterDateTo.value,
    );

    isLoadingMore.value = false;

    if (response.success && response.data != null) {
      transactions.addAll(response.data!);
      hasMore.value = response.data!.length == _pageSize;
      _currentOffset += response.data!.length;
    }
  }

  Future<void> refreshTransactions() async {
    await fetchTransactions();
  }

  void applyFilters({
    String? type,
    String? fromAccountId,
    String? categoryId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) {
    filterType.value = type;
    filterFromAccountId.value = fromAccountId;
    filterCategoryId.value = categoryId;
    filterDateFrom.value = dateFrom;
    filterDateTo.value = dateTo;
    fetchTransactions();
  }

  void clearFilters() {
    filterType.value = null;
    filterFromAccountId.value = null;
    filterCategoryId.value = null;
    filterDateFrom.value = null;
    filterDateTo.value = null;
    fetchTransactions();
  }

  bool get hasActiveFilters =>
      filterType.value != null ||
      filterFromAccountId.value != null ||
      filterCategoryId.value != null ||
      filterDateFrom.value != null ||
      filterDateTo.value != null;

  void clearFields() {
    amountController.clear();
    descriptionController.clear();
    selectedTransactionType.value = 'expense';
    selectedFromAccountId.value =
        accounts.isNotEmpty ? accounts.first.id : null;
    selectedToAccountId.value = null;
    selectedCategoryId.value = null;
    selectedDate.value = DateTime.now();
    errorMessage.value = '';
  }

  Future<void> createTransaction() async {
    if (!_validateFields()) return;

    isSubmitting.value = true;
    errorMessage.value = '';

    final amount = double.tryParse(amountController.text.trim()) ?? 0;
    final type = selectedTransactionType.value;
    String? fromAccountId;
    String? toAccountId;

    if (type == 'expense') {
      fromAccountId = selectedFromAccountId.value;
    } else if (type == 'income') {
      toAccountId = selectedToAccountId.value;
    } else {
      fromAccountId = selectedFromAccountId.value;
      toAccountId = selectedToAccountId.value;
    }

    final response = await _transactionRepository.createTransaction(
      transactionType: type,
      amount: amount,
      fromAccountId: fromAccountId,
      toAccountId: toAccountId,
      categoryId: selectedCategoryId.value,
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      transactionDate: selectedDate.value,
    );

    isSubmitting.value = false;

    if (response.success) {
      Get.snackbar(
        'Success',
        'Transaction created successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().refreshData();
      }
      clearFields();
      Get.back();
    } else {
      errorMessage.value =
          response.message ?? 'Failed to create transaction';
    }
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
    final txType = selectedTransactionType.value;
    if (txType == 'expense' && selectedFromAccountId.value == null) {
      errorMessage.value = 'Expense requires a source account';
      return false;
    }
    if (txType == 'income' && selectedToAccountId.value == null) {
      errorMessage.value = 'Income requires a destination account';
      return false;
    }
    if (txType == 'transfer') {
      if (selectedFromAccountId.value == null ||
          selectedToAccountId.value == null) {
        errorMessage.value =
            'Transfer requires both source and destination accounts';
        return false;
      }
      if (selectedFromAccountId.value == selectedToAccountId.value) {
        errorMessage.value =
            'Source and destination accounts must be different';
        return false;
      }
    }
    return true;
  }

  String getAccountName(String accountId) {
    final account = accounts.firstWhereOrNull((a) => a.id == accountId);
    return account?.name ?? 'Unknown';
  }

  List<CategoryModel> get categoriesForSelectedType {
    if (selectedTransactionType.value == 'transfer') {
      return const <CategoryModel>[];
    }
    return categories
        .where((c) => c.type.apiValue == selectedTransactionType.value)
        .toList();
  }
}
