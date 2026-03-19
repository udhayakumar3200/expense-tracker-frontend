import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/transaction_controller.dart';

class TransactionListScreen extends GetView<TransactionController> {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormat = DateFormat('MMM dd, yyyy');

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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refreshTransactions,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'No transactions yet',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your first transaction',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshTransactions,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: controller.transactions.length,
            itemBuilder: (context, index) {
              final transaction = controller.transactions[index];
              final isExpense = transaction.transactionType == 'expense';
              final isIncome = transaction.transactionType == 'income';
              final isTransfer = transaction.transactionType == 'transfer';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getTypeColor(transaction.transactionType)
                        .withValues(alpha: 0.1),
                    child: Icon(
                      _getTypeIcon(transaction.transactionType),
                      color: _getTypeColor(transaction.transactionType),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          transaction.category ?? transaction.displayType,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${isExpense ? '-' : isIncome ? '+' : ''}${currencyFormat.format(transaction.amount)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isExpense
                              ? Colors.red[700]
                              : isIncome
                                  ? Colors.green[700]
                                  : Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (transaction.description != null &&
                          transaction.description!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            transaction.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            dateFormat.format(transaction.transactionDate),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                          if (isTransfer) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_forward,
                                size: 12, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                controller.getAccountName(
                                    transaction.toAccountId ?? 0),
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  isThreeLine:
                      transaction.description != null &&
                      transaction.description!.isNotEmpty,
                ),
              );
            },
          ),
        );
      }),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'expense':
        return Icons.arrow_upward;
      case 'income':
        return Icons.arrow_downward;
      case 'transfer':
        return Icons.swap_horiz;
      default:
        return Icons.receipt;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'expense':
        return Colors.red;
      case 'income':
        return Colors.green;
      case 'transfer':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
