import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/account_repository.dart';
import 'dashboard_controller.dart';

class AccountController extends GetxController {
  final AccountRepository _accountRepository = AccountRepository();

  final nameController = TextEditingController();
  final balanceController = TextEditingController();

  final RxString selectedAccountType = 'bank'.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final List<Map<String, String>> accountTypes = [
    {'value': 'bank', 'label': 'Bank Account'},
    {'value': 'cash', 'label': 'Cash'},
    {'value': 'upi', 'label': 'UPI'},
    {'value': 'credit_card', 'label': 'Credit Card'},
  ];

  @override
  void onClose() {
    nameController.dispose();
    balanceController.dispose();
    super.onClose();
  }

  void clearFields() {
    nameController.clear();
    balanceController.clear();
    selectedAccountType.value = 'bank';
    errorMessage.value = '';
  }

  Future<void> createAccount() async {
    if (!_validateFields()) return;

    isLoading.value = true;
    errorMessage.value = '';

    final amount = double.tryParse(balanceController.text.trim()) ?? 0;
    final isCreditCard = selectedAccountType.value == 'credit_card';

    final response = await _accountRepository.createAccount(
      name: nameController.text.trim(),
      accountType: selectedAccountType.value,
      balance: isCreditCard ? 0 : amount,
      creditLimit: isCreditCard ? amount : null,
    );

    isLoading.value = false;

    if (response.success) {
      Get.snackbar(
        'Success',
        'Account created successfully!',
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
      errorMessage.value = response.message ?? 'Failed to create account';
    }
  }

  bool _validateFields() {
    if (nameController.text.trim().isEmpty) {
      errorMessage.value = 'Account name is required';
      return false;
    }

    final isCreditCard = selectedAccountType.value == 'credit_card';
    final fieldLabel = isCreditCard ? 'Credit limit' : 'Initial balance';
    final text = balanceController.text.trim();

    if (text.isEmpty) {
      errorMessage.value = '$fieldLabel is required';
      return false;
    }

    final parsed = double.tryParse(text);
    if (parsed == null) {
      errorMessage.value =
          'Please enter a valid ${fieldLabel.toLowerCase()} amount';
      return false;
    }

    if (parsed < 0) {
      errorMessage.value = '$fieldLabel cannot be negative';
      return false;
    }

    if (isCreditCard && parsed <= 0) {
      errorMessage.value = 'Credit limit must be greater than 0';
      return false;
    }

    return true;
  }
}
