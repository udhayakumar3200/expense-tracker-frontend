import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/category_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/category_model.dart';
import '../../widgets/category_form_sheet.dart';
import '../../widgets/empty_state.dart';

class CategoryManagementScreen extends GetView<CategoryController> {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchCategories,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return EmptyState(
            icon: Icons.error_outline,
            title: 'Something went wrong',
            subtitle: controller.errorMessage.value,
            buttonText: 'Retry',
            onButtonPressed: controller.fetchCategories,
          );
        }

        if (controller.categories.isEmpty) {
          return const EmptyState(
            icon: Icons.label_outline,
            title: 'No categories yet',
            subtitle: 'Tap + to add your first category',
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchCategories,
          child: ListView(
            padding: AppSpacing.screenPadding,
            children: [
              if (controller.expenseCategories.isNotEmpty) ...[
                _SectionLabel('Expense'),
                ...controller.expenseCategories
                    .map((c) => _CategoryTile(category: c)),
              ],
              if (controller.incomeCategories.isNotEmpty) ...[
                AppSpacing.verticalMd,
                _SectionLabel('Income'),
                ...controller.incomeCategories
                    .map((c) => _CategoryTile(category: c)),
              ],
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => CategoryFormSheet.show(),
        tooltip: 'Add Category',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(label.toUpperCase(), style: AppTextStyles.labelSmall),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final CategoryModel category;
  const _CategoryTile({required this.category});

  @override
  Widget build(BuildContext context) {
    final isExpense = category.type == CategoryType.expense;
    final color = isExpense ? AppColors.expense : AppColors.income;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(Icons.label_outline, color: color),
        ),
        title: Text(category.name, style: AppTextStyles.bodyMediumBold),
        subtitle: Text(
          isExpense ? 'Expense' : 'Income',
          style: AppTextStyles.caption,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => CategoryFormSheet.show(category: category),
      ),
    );
  }
}
