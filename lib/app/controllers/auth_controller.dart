import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/auth_repository.dart';
import '../repositories/account_repository.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isLoginMode = true.obs;
  final RxString errorMessage = ''.obs;
  final AccountRepository _accountRepository = AccountRepository();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  void toggleMode() {
    isLoginMode.value = !isLoginMode.value;
    errorMessage.value = '';
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    errorMessage.value = '';
  }

  Future<void> login() async {
    if (!_validateFields()) return;

    isLoading.value = true;
    errorMessage.value = '';

    final response = await _authRepository.login(
      emailController.text.trim(),
      passwordController.text,
    );

    isLoading.value = false;

    if (response.success) {
      // Example usage after Supabase sign-in:
      // the API client will send Authorization: Bearer <session.accessToken>.
      await _accountRepository.getAccounts();
      clearFields();
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      errorMessage.value = response.message ?? 'Login failed';
    }
  }

  Future<void> register() async {
    if (!_validateFields()) return;

    isLoading.value = true;
    errorMessage.value = '';

    final response = await _authRepository.register(
      emailController.text.trim(),
      passwordController.text,
      name: nameController.text.trim().isEmpty
          ? null
          : nameController.text.trim(),
    );

    isLoading.value = false;

    if (response.success) {
      Get.snackbar(
        'Success',
        'Registration successful! Please check your email to verify your account.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      isLoginMode.value = true;
      passwordController.clear();
      nameController.clear();
    } else {
      errorMessage.value = response.message ?? 'Registration failed';
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  Future<bool> checkLoginStatus() async {
    return await _authRepository.isLoggedIn();
  }

  bool _validateFields() {
    if (emailController.text.trim().isEmpty) {
      errorMessage.value = 'Email is required';
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      errorMessage.value = 'Please enter a valid email';
      return false;
    }

    if (passwordController.text.isEmpty) {
      errorMessage.value = 'Password is required';
      return false;
    }

    if (passwordController.text.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters';
      return false;
    }

    return true;
  }
}
