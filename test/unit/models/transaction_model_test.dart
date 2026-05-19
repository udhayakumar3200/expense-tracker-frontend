import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/app/models/transaction_model.dart';

void main() {
  group('TransactionUpdateRequest.toJson', () {
    test('omits null fields', () {
      final req = TransactionUpdateRequest(amount: 50.0);
      expect(req.toJson(), {'amount': 50.0});
    });

    test('includes all provided fields', () {
      final date = DateTime(2026, 5, 19);
      final req = TransactionUpdateRequest(
        amount: 100.0,
        type: TransactionType.expense,
        transactionDate: date,
        fromAccountId: 'acc-1',
        categoryId: 'cat-1',
        description: 'Lunch',
      );
      expect(req.toJson(), {
        'amount': 100.0,
        'type': 'expense',
        'transaction_date': date.toIso8601String(),
        'from_account_id': 'acc-1',
        'category_id': 'cat-1',
        'description': 'Lunch',
      });
    });
  });
}
