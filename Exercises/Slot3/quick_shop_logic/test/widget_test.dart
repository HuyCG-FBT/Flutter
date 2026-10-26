import 'package:flutter_test/flutter_test.dart';
import 'package:quick_shop_logic/models/product.dart';
import 'package:quick_shop_logic/services/product_service.dart';

void main() {
  group('Product Model & Service Logic Tests', () {
    test('Product constructor initializes properties', () {
      final p = Product(id: "p1", name: "Mouse", price: 20.0);
      expect(p.id, "p1");
      expect(p.name, "Mouse");
      expect(p.price, 20.0);
    });

    test('ProductService filterByMaxPrice correctly filters products', () {
      final service = ProductService();
      final cheapProducts = service.filterByMaxPrice(100.0);

      expect(cheapProducts.isNotEmpty, isTrue);
      for (final p in cheapProducts) {
        expect(p.price < 100.0, isTrue);
      }
    });

    test('ProductService calculateTotalPrice correctly sums prices', () {
      final service = ProductService();
      final products = [
        Product(id: "1", name: "Item 1", price: 10.0),
        Product(id: "2", name: "Item 2", price: 25.5),
      ];

      final total = service.calculateTotalPrice(products);
      expect(total, 35.5);
    });
  });
}
