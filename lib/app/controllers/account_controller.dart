import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/account_repository.dart';
import 'dashboard_controller.dart';
import 'transaction_controller.dart';

class AccountController extends GetxController {
  final AccountRepository _accountRepository = AccountRepository();

  final nameController = TextEditingController();
  final balanceController = TextEditingController();
  final outstandingBalanceController = TextEditingController();

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
    outstandingBalanceController.dispose();
    super.onClose();
  }

  void clearFields() {
    nameController.clear();
    balanceController.clear();
    outstandingBalanceController.clear();
    selectedAccountType.value = 'bank';
    errorMessage.value = '';
  }

  Future<void> createAccount() async {
    if (!_validateFields()) return;

    isLoading.value = true;
    errorMessage.value = '';

    final amount = double.tryParse(balanceController.text.trim()) ?? 0;
    final isCreditCard = selectedAccountType.value == 'credit_card';
    final outstandingAmount =
        double.tryParse(outstandingBalanceController.text.trim()) ?? 0;

    final response = await _accountRepository.createAccount(
      name: nameController.text.trim(),
      accountType: selectedAccountType.value,
      balance: isCreditCard ? 0 : amount,
      creditLimit: isCreditCard ? amount : null,
      outstandingBalance: isCreditCard ? outstandingAmount : null,
    );

    isLoading.value = false;

    if (response.success) {
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().refreshData();
      }
      if (Get.isRegistered<TransactionController>()) {
        Get.find<TransactionController>().fetchAccounts();
      }

      clearFields();
      Get.back();

      Get.snackbar(
        'Success',
        'Account created successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
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

    if (isCreditCard) {
      final outstandingText = outstandingBalanceController.text.trim();
      if (outstandingText.isEmpty) {
        errorMessage.value = 'Outstanding balance is required';
        return false;
      }
      final parsedOutstanding = double.tryParse(outstandingText);
      if (parsedOutstanding == null) {
        errorMessage.value =
            'Please enter a valid outstanding balance amount';
        return false;
      }
      if (parsedOutstanding < 0) {
        errorMessage.value = 'Outstanding balance cannot be negative';
        return false;
      }
      if (parsedOutstanding > parsed) {
        errorMessage.value =
            'Outstanding balance cannot exceed credit limit';
        return false;
      }
    }

    return true;
  }
}
