import 'package:flutter_test/flutter_test.dart';
import 'package:product_explorer/models/product.dart';

void main() {
  group('Product Model Tests', () {
    test('Product.fromJson parses valid JSON correctly', () {
      final json = {
        'id': 1,
        'title': 'Fjallraven - Foldsack No. 1 Backpack',
        'price': 109.95,
        'description': 'Your perfect pack for everyday use and walks in the forest.',
        'image': 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
      };

      final product = Product.fromJson(json);

      expect(product.id, 1);
      expect(product.title, 'Fjallraven - Foldsack No. 1 Backpack');
      expect(product.price, 109.95);
      expect(product.description, 'Your perfect pack for everyday use and walks in the forest.');
      expect(product.image, 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg');

      final output = product.toJson();
      expect(output['id'], 1);
      expect(output['price'], 109.95);
    });
  });
}
