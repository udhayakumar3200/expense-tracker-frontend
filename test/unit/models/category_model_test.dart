import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/app/models/category_model.dart';

void main() {
  group('CategoryUpdateRequest.toJson', () {
    test('omits null fields', () {
      final req = CategoryUpdateRequest(name: 'Food');
      expect(req.toJson(), {'name': 'Food'});
    });

    test('includes all provided fields', () {
      final req = CategoryUpdateRequest(
        name: 'Food',
        type: CategoryType.expense,
      );
      expect(req.toJson(), {'name': 'Food', 'type': 'expense'});
    });
  });
}
