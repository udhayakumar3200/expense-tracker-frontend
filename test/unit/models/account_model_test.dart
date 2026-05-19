import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/app/models/account_model.dart';

void main() {
  group('AccountUpdateRequest.toJson', () {
    test('omits null fields', () {
      final req = AccountUpdateRequest(name: 'Savings');
      expect(req.toJson(), {'name': 'Savings'});
    });

    test('includes all provided fields', () {
      final req = AccountUpdateRequest(
        name: 'Savings',
        type: AccountType.bank,
        currentBalance: 1500.0,
      );
      expect(req.toJson(), {
        'name': 'Savings',
        'type': 'bank',
        'current_balance': 1500.0,
      });
    });

    test('empty request produces empty map', () {
      final req = AccountUpdateRequest();
      expect(req.toJson(), <String, dynamic>{});
    });
  });
}
