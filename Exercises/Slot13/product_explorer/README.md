# Product Explorer App 🛍️📱

Ứng dụng Flutter theo mô hình **Master–Detail API App** kết nối FakeStore API, render danh sách với `ListView.builder`, quản lý trạng thái bất đồng bộ qua `FutureBuilder` (Loading / Error / Empty / Data) và kỹ thuật **Cache Future trong `initState()`** nhằm tránh gọi API lặp (PRM393 - **Slot 13**).

---

## 1. Cấu trúc thư mục dự án

```text
lib/
├── main.dart                          # Khởi chạy ProductExplorerApp với Material 3
├── models/
│   └── product.dart                   # Model Product (id, title, description, image, price)
├── services/
│   └── api_service.dart               # Tầng mạng gọi FakeStore API (fetchProducts, fetchProductById)
├── screens/
│   ├── product_list_screen.dart       # Màn hình Master: Danh sách sản phẩm (FutureBuilder + ListView.builder)
│   └── product_detail_screen.dart     # Màn hình Detail: Chi tiết sản phẩm theo ID (FutureBuilder riêng + Retry)
└── widgets/
    ├── loading_widget.dart            # Widget vòng xoay tải kèm thông điệp tái sử dụng
    └── error_widget.dart              # Widget báo lỗi mạng kèm nút Retry tái sử dụng
test/
├── product_model_test.dart            # Unit tests kiểm thử parse JSON sang Product model
└── widget_test.dart                   # Widget tests kiểm thử LoadingWidget và AppErrorWidget
```

---

## 2. Kỹ thuật & Tư duy Cốt lõi

### A. Tách Tầng Dữ liệu & Gọi REST API
- Sử dụng FakeStore API:
  - Danh sách: `GET https://fakestoreapi.com/products`
  - Chi tiết theo ID: `GET https://fakestoreapi.com/products/{id}`
- Tách riêng lớp `ApiService` khỏi giao diện UI, hỗ trợ Dependency Injection (`http.Client`) phục vụ testing.

### B. Kỹ thuật Cache Future trong `initState()` (Tránh gọi API lặp)
- **Sai lầm kinh điển**: Gọi `ApiService.fetchProducts()` trực tiếp trong `build()` của widget:
  - Khi người dùng cuộn list, đổi theme, hay gọi `setState()`, hàm `build()` sẽ kích hoạt lại -> App gọi lại API liên tục làm lãng phí băng thông và gây giật lag UI.
- **Giải pháp**: Khởi tạo và lưu trữ Future vào biến thành viên trong `initState()`:
  ```dart
  late Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchProducts(); // Cache Future tại đây
  }
  ```
- Khi người dùng bấm nút **Retry**: Chỉ cần gán lại `_future` mới trong `setState()`:
  ```dart
  void _retry() {
    setState(() {
      _future = ApiService.fetchProducts();
    });
  }
  ```

### C. Quản lý 4 Trạng thái với `FutureBuilder`
1. **Loading**: `snapshot.connectionState == ConnectionState.waiting` -> Trả về `LoadingWidget(message: "Loading products...")`.
2. **Error**: `snapshot.hasError` -> Trả về `AppErrorWidget(message: ..., onRetry: _retry)`.
3. **Empty**: `snapshot.data == null || snapshot.data!.isEmpty` -> Trả về thông báo danh sách trống.
4. **Data**: Render danh sách mượt mà với `ListView.builder` và điều hướng sang màn hình Detail:
   ```dart
   Navigator.push(
     context,
     MaterialPageRoute(
       builder: (_) => ProductDetailScreen(productId: product.id),
     ),
   );
   ```

### D. Xử lý Ảnh mạng An toàn với `errorBuilder`
- Bọc ảnh `Image.network` với thuộc tính `errorBuilder`:
  ```dart
  Image.network(
    product.image,
    errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported),
  )
  ```
  Giúp app hiển thị icon dự phòng thay vì bị crash hoặc hiện khung vàng sọc đen khi URL ảnh lỗi hoặc mất mạng.

---

## 3. Hướng dẫn chạy & Kiểm thử

1. Chuyển vào thư mục:
   ```bash
   cd Exercises/Slot13/product_explorer
   ```
2. Cài đặt dependencies:
   ```bash
   flutter pub get
   ```
3. Phân tích tĩnh (Static Analysis):
   ```bash
   flutter analyze
   ```
4. Chạy kiểm thử tự động (Unit & Widget Tests):
   ```bash
   flutter test
   ```
5. Khởi chạy ứng dụng:
   ```bash
   flutter run
   ```
