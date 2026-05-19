import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final String itemName;
  final String itemType;
  final VoidCallback onConfirm;

  const DeleteConfirmDialog({
    super.key,
    required this.itemName,
    required this.itemType,
    required this.onConfirm,
  });

  static Future<void> show({
    required String itemName,
    required String itemType,
    required VoidCallback onConfirm,
  }) {
    return Get.dialog(
      DeleteConfirmDialog(
        itemName: itemName,
        itemType: itemType,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete $itemType?', style: AppTextStyles.h4),
      content: Text(
        'Are you sure you want to delete "$itemName"? This cannot be undone.',
        style: AppTextStyles.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            onConfirm();
          },
          child: Text(
            'Delete',
            style: TextStyle(color: AppColors.error),
          ),
        ),
      ],
    );
  }
}
