import 'package:get/get.dart';
import '../models/account_model.dart';
import '../repositories/account_repository.dart';

class DashboardController extends GetxController {
  final AccountRepository _accountRepository = AccountRepository();

  final RxList<AccountModel> accounts = <AccountModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxDouble totalBalance = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // TODO: Uncomment for production
    // fetchAccounts();
    
    // Mock data for UI preview
    _loadMockData();
  }

  void _loadMockData() {
    accounts.value = [
      AccountModel(id: 1, name: 'Main Savings', accountType: 'bank', balance: 5000.0, userId: 1),
      AccountModel(id: 2, name: 'Cash Wallet', accountType: 'cash', balance: 500.0, userId: 1),
      AccountModel(id: 3, name: 'GPay', accountType: 'upi', balance: 1200.0, userId: 1),
      AccountModel(id: 4, name: 'Credit Card', accountType: 'credit_card', balance: -250.0, userId: 1),
    ];
    _calculateTotalBalance();
  }

  Future<void> fetchAccounts() async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await _accountRepository.getAccounts();

    isLoading.value = false;

    if (response.success && response.data != null) {
      accounts.value = response.data!;
      _calculateTotalBalance();
    } else {
      errorMessage.value = response.message ?? 'Failed to fetch accounts';
    }
  }

  void _calculateTotalBalance() {
    double total = 0;
    for (final account in accounts) {
      total += account.balance;
    }
    totalBalance.value = total;
  }

  Future<void> refreshData() async {
    await fetchAccounts();
  }
}
