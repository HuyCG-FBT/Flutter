import 'package:flutter/material.dart';
import 'models/product.dart';
import 'services/product_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quick Shop Logic Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: QuickShopPage(),
    );
  }
}

class QuickShopPage extends StatefulWidget {
  const QuickShopPage({super.key});

  @override
  State<QuickShopPage> createState() => _QuickShopPageState();
}

class _QuickShopPageState extends State<QuickShopPage> {
  // 1️⃣ Tạo service (quản lý toàn bộ logic nghiệp vụ)
  final ProductService _service = ProductService();

  // Trạng thái lọc: true = chỉ sản phẩm giá rẻ (< 100$), false = tất cả
  bool _onlyCheap = true;

  // Level 1 (Logic Hàm): Viết hàm riêng bên ngoài hàm build, rồi gọi trong onTap
  void _handleProductTap(Product product) {
    _service.handleAddToCart(product);

    // Hiển thị thông báo nhỏ lên UI phản hồi lại hành động
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("🛒 Đã thêm ${product.name} vào giỏ hàng!"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ❌ KHÔNG xử lý logic lọc trong hàm build
    // ✅ UI CHỈ LẤY KẾT QUẢ ĐÃ ĐƯỢC XỬ LÝ TỪ SERVICE
    final List<Product> products = _onlyCheap
        ? _service.filterByMaxPrice(100.0) // Bước 6: lọc < 100$
        : _service.getAllProducts();

    // Level 2 (Logic Toán): Tính tổng tiền các sản phẩm đang hiển thị
    final double totalPrice = _service.calculateTotalPrice(products);

    return Scaffold(
      appBar: AppBar(
        title: Text(_onlyCheap
            ? "Sản phẩm giá rẻ (< 100\$)"
            : "Tất cả sản phẩm"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Nút chuyển đổi lọc nhanh để kiểm chứng logic
          IconButton(
            tooltip: _onlyCheap ? "Xem tất cả" : "Chỉ xem giá rẻ",
            icon: Icon(_onlyCheap ? Icons.filter_alt : Icons.filter_alt_off),
            onPressed: () {
              setState(() {
                _onlyCheap = !_onlyCheap;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Thanh tổng kết thông tin (Level 2)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.deepPurple.withValues(alpha: 0.08),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Đang hiển thị: ${products.length} sản phẩm",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  "Tổng tiền: \$${totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
          // Danh sách sản phẩm (Dùng .map biến đổi List<Product> -> List<Widget>)
          Expanded(
            child: ListView(
              children: products.map((product) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    // Level 3 (Logic Class): Hiển thị ảnh bằng Image.network
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: product.imageUrl.isNotEmpty
                          ? Image.network(
                              product.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.shopping_bag, size: 40),
                            )
                          : const Icon(Icons.shopping_bag, size: 40),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      "\$${product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: product.price < 100 ? Colors.green[700] : Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart, color: Colors.deepPurple),
                      // UI chỉ GỌI logic callback
                      onPressed: () => _handleProductTap(product),
                    ),
                    // Nhấn vào item cũng gọi hàm xử lý (Level 1)
                    onTap: () => _handleProductTap(product),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
