import '../models/product.dart';

// Tạo một List chứa các object Product giả lập
List<Product> rawProducts = [
  Product(
    id: "p1",
    name: "Laptop Gaming",
    price: 1200.0,
    imageUrl: "https://picsum.photos/seed/laptop/200/200",
  ),
  Product(
    id: "p2",
    name: "Chuột không dây",
    price: 25.0, // Giá rẻ
    imageUrl: "https://picsum.photos/seed/mouse/200/200",
  ),
  Product(
    id: "p3",
    name: "Bàn phím cơ",
    price: 80.0,
    imageUrl: "https://picsum.photos/seed/keyboard/200/200",
  ),
  Product(
    id: "p4",
    name: "Lót chuột",
    price: 10.0, // Giá rẻ
    imageUrl: "https://picsum.photos/seed/mousepad/200/200",
  ),
  Product(
    id: "p5",
    name: "Màn hình 4K",
    price: 450.0,
    imageUrl: "https://picsum.photos/seed/monitor/200/200",
  ),
];
