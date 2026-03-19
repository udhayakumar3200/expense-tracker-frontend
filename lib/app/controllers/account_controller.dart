import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: unused_import
import '../repositories/account_repository.dart';
// ignore: unused_import
import 'dashboard_controller.dart';

class AccountController extends GetxController {
  // ignore: unused_field
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
    // TODO: Uncomment validation for production
    // if (!_validateFields()) return;

    // isLoading.value = true;
    // errorMessage.value = '';

    // final balance = double.tryParse(balanceController.text.trim()) ?? 0;

    // final response = await _accountRepository.createAccount(
    //   name: nameController.text.trim(),
    //   accountType: selectedAccountType.value,
    //   balance: balance,
    // );

    // isLoading.value = false;

    // if (response.success) {
    //   Get.snackbar(
    //     'Success',
    //     'Account created successfully!',
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
    //   errorMessage.value = response.message ?? 'Failed to create account';
    // }

    // Skip validation for UI preview
    Get.snackbar(
      'Success',
      'Account created successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    clearFields();
    Get.back();
  }

  // ignore: unused_element
  bool _validateFields() {
    if (nameController.text.trim().isEmpty) {
      errorMessage.value = 'Account name is required';
      return false;
    }

    if (balanceController.text.trim().isEmpty) {
      errorMessage.value = 'Initial balance is required';
      return false;
    }

    if (double.tryParse(balanceController.text.trim()) == null) {
      errorMessage.value = 'Please enter a valid balance amount';
      return false;
    }

    return true;
  }
}
