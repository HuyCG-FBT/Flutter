// ignore_for_file: avoid_print

import '../models/product.dart';
import '../data/data_source.dart';

class ProductService {
  /// Lấy toàn bộ sản phẩm
  List<Product> getAllProducts() {
    return rawProducts;
  }

  /// Lấy sản phẩm giá rẻ (< 100)
  List<Product> getCheapProducts() {
    return rawProducts.where((p) => p.price < 100).toList();
  }

  /// Lọc sản phẩm theo giá tối đa (Bước 6.1)
  List<Product> filterByMaxPrice(double maxPrice) {
    return rawProducts.where((product) {
      return product.price < maxPrice;
    }).toList();
  }

  /// Xử lý khi người dùng chọn sản phẩm
  void handleAddToCart(Product product) {
    print("Đã chọn mua: ${product.name}");
    print("Giá tiền: \$${product.price}");
  }

  /// Bài tập mở rộng Level 2 (Logic Toán):
  /// Tính tổng tiền của các sản phẩm đang hiển thị và in ra Console
  double calculateTotalPrice(List<Product> products) {
    double total = 0.0;
    for (final p in products) {
      total += p.price;
    }
    print(">> Tổng tiền các sản phẩm: \$$total");
    return total;
  }
}
