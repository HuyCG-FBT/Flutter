class Product {
  // 1. Thuộc tính (Properties) - Dùng final vì dữ liệu không đổi sau khi tạo
  final String id;
  final String name;
  final double price;
  // Bài tập mở rộng Level 3: Thêm imageUrl
  final String imageUrl;

  // 2. Constructor - Dùng Named Parameters và required
  Product({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl = '',
  });
}
