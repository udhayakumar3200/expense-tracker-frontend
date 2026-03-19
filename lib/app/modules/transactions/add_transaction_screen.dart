import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/transaction_controller.dart';

class AddTransactionScreen extends GetView<TransactionController> {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Obx(() {
        if (controller.accounts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'No accounts available',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please create an account first',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: controller.selectedTransactionType.value,
                decoration: const InputDecoration(
                  labelText: 'Transaction Type',
                  prefixIcon: Icon(Icons.swap_vert),
                  border: OutlineInputBorder(),
                ),
                items: controller.transactionTypes
                    .map((type) => DropdownMenuItem(
                          value: type['value'],
                          child: Text(type['label']!),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedTransactionType.value = value;
                  }
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller.amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: controller.selectedFromAccountId.value,
                decoration: InputDecoration(
                  labelText: controller.selectedTransactionType.value == 'income'
                      ? 'To Account'
                      : 'From Account',
                  prefixIcon: const Icon(Icons.account_balance),
                  border: const OutlineInputBorder(),
                ),
                items: controller.accounts
                    .map((account) => DropdownMenuItem(
                          value: account.id,
                          child: Text('${account.name} (${account.displayType})'),
                        ))
                    .toList(),
                onChanged: (value) {
                  controller.selectedFromAccountId.value = value;
                },
              ),
              if (controller.selectedTransactionType.value == 'transfer') ...[
                const SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  value: controller.selectedToAccountId.value,
                  decoration: const InputDecoration(
                    labelText: 'To Account',
                    prefixIcon: Icon(Icons.account_balance),
                    border: OutlineInputBorder(),
                  ),
                  items: controller.accounts
                      .where((a) => a.id != controller.selectedFromAccountId.value)
                      .map((account) => DropdownMenuItem(
                            value: account.id,
                            child:
                                Text('${account.name} (${account.displayType})'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.selectedToAccountId.value = value;
                  },
                ),
              ],
              const SizedBox(height: 20),
              TextField(
                controller: controller.categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category (Optional)',
                  hintText: 'e.g., Food, Transport, Salary',
                  prefixIcon: Icon(Icons.category_outlined),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller.descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Add a note',
                  prefixIcon: Icon(Icons.notes),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => controller.selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    dateFormat.format(controller.selectedDate.value),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (controller.errorMessage.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : controller.createTransaction,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: controller.isSubmitting.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Create Transaction',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
