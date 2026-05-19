import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/category_model.dart';
import 'custom_button.dart';
import 'custom_dropdown.dart';
import 'custom_text_field.dart';
import 'error_text.dart';

class CategoryFormSheet extends StatefulWidget {
  final CategoryModel? category;

  const CategoryFormSheet({super.key, this.category});

  static void show({CategoryModel? category}) {
    Get.bottomSheet(
      CategoryFormSheet(category: category),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  State<CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends State<CategoryFormSheet> {
  late final TextEditingController _nameController;
  late String _selectedType;
  bool _isLoading = false;
  String _errorMessage = '';

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.category?.name ?? '');
    _selectedType = widget.category?.type.apiValue ?? 'expense';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorMessage = 'Category name is required');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final ctrl = Get.find<CategoryController>();
    bool success;

    if (_isEditing) {
      success = await ctrl.updateCategory(
        widget.category!.id,
        name,
        CategoryTypeX.fromApi(_selectedType),
      );
    } else {
      success = await ctrl.createCategory(name, _selectedType);
    }

    if (!mounted) return;

    if (success) {
      Get.back();
      Get.snackbar(
        _isEditing ? 'Updated' : 'Created',
        'Category ${_isEditing ? 'updated' : 'created'} successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Failed to ${_isEditing ? 'update' : 'create'} category';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      padding: AppSpacing.screenPadding.copyWith(
        bottom: AppSpacing.screenPadding.bottom +
            MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.textHint,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              _isEditing ? 'Edit Category' : 'New Category',
              style: AppTextStyles.h2,
            ),
            AppSpacing.verticalMd,
            CustomTextField(
              controller: _nameController,
              label: 'Category Name',
              hint: 'e.g. Groceries',
              prefixIcon: Icons.label_outline,
            ),
            AppSpacing.verticalMd,
            CategoryTypeDropdown(
              value: _selectedType,
              onChanged: (v) =>
                  setState(() => _selectedType = v ?? _selectedType),
            ),
            if (_errorMessage.isNotEmpty) ...[
              AppSpacing.verticalSm,
              ErrorText(message: _errorMessage),
            ],
            AppSpacing.verticalLg,
            CustomButton(
              text: _isEditing ? 'Save Changes' : 'Create Category',
              onPressed: _isLoading ? null : _submit,
              isLoading: _isLoading,
            ),
            AppSpacing.verticalMd,
          ],
        ),
      ),
    );
  }
}
