import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/transaction_controller.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/transaction_tile.dart';
import '../../widgets/empty_state.dart';

class TransactionListScreen extends GetView<TransactionController> {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshTransactions,
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
            onButtonPressed: controller.refreshTransactions,
          );
        }

        if (controller.transactions.isEmpty) {
          return const EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'No transactions yet',
            subtitle: 'Add your first transaction',
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshTransactions,
          child: ListView.builder(
            padding: AppSpacing.paddingVerticalMd,
            itemCount: controller.transactions.length,
            itemBuilder: (context, index) {
              final transaction = controller.transactions[index];
              return TransactionTile(
                transaction: transaction,
                toAccountName: transaction.toAccountId != null
                    ? controller.getAccountName(transaction.toAccountId!)
                    : null,
              );
            },
          ),
        );
      }),
    );
  }
}
