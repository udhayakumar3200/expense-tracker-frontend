import 'package:get/get.dart';
import '../models/category_model.dart';
import '../repositories/category_repository.dart';
import 'transaction_controller.dart';

class CategoryController extends GetxController {
  final CategoryRepository _categoryRepository = CategoryRepository();

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    errorMessage.value = '';
    final response = await _categoryRepository.getCategories();
    isLoading.value = false;
    if (response.success && response.data != null) {
      categories.value = response.data!;
    } else {
      errorMessage.value =
          response.message ?? 'Failed to fetch categories';
    }
  }

  Future<bool> createCategory(String name, String type) async {
    final response = await _categoryRepository.createCategory(
      name: name,
      type: type,
    );
    if (response.success) {
      await fetchCategories();
      _notifyTransactionController();
      return true;
    }
    return false;
  }

  Future<bool> updateCategory(
      String id, String name, CategoryType type) async {
    final request = CategoryUpdateRequest(name: name, type: type);
    final response = await _categoryRepository.updateCategory(id, request);
    if (response.success) {
      await fetchCategories();
      _notifyTransactionController();
      return true;
    }
    return false;
  }

  void _notifyTransactionController() {
    if (Get.isRegistered<TransactionController>()) {
      Get.find<TransactionController>().fetchCategories();
    }
  }

  List<CategoryModel> get expenseCategories =>
      categories.where((c) => c.type == CategoryType.expense).toList();

  List<CategoryModel> get incomeCategories =>
      categories.where((c) => c.type == CategoryType.income).toList();
}
