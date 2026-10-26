# Slot 3: Dart Core Logic & UI Integration 🎯

Slot này tập trung vào tư duy **"Logic First, UI Later"** - tách biệt hoàn toàn tầng xử lý dữ liệu (Dart Core) ra khỏi tầng hiển thị giao diện (Flutter UI).

---

## 📂 Danh mục bài tập

### 1️⃣ Bài tập tổng hợp 2: Student Manager (`student_manager`)
- **Mục tiêu**: Hiểu rõ Dart xử lý logic ở đâu, truyền dữ liệu từ `StudentService` sang UI `main.dart`.
- **Cấu trúc**:
  ```
  student_manager/
  ├── lib/
  │   ├── models/
  │   │   └── student.dart          # Class Student, Constructor, display()
  │   ├── services/
  │   │   └── student_service.dart  # Logic lọc GPA (where), chuyển đổi chuỗi (map)
  │   ├── widgets/
  │   │   └── student_tile.dart     # Tách widget hiển thị (Bài tập mở rộng)
  │   └── main.dart                 # Giao diện hiển thị danh sách sinh viên
  ```
- **Tính năng & Bài tập mở rộng đã hoàn thành**:
  - [x] Lọc sinh viên xuất sắc (`GPA >= 3.6`) bằng `.where()`.
  - [x] Chuyển đổi dữ liệu sang định dạng hiển thị bằng `.map()`.
  - [x] Bài tập mở rộng: Named constructor `Student.excellent(...)`.
  - [x] Bài tập mở rộng: Thêm bộ lọc `GPA >= 3.5` và `Tất cả` linh hoạt.
  - [x] Bài tập mở rộng: Tách widget hiển thị (`StudentTile`).

### 2️⃣ Bài tập tổng hợp 3: Quick Shop MVP (`quick_shop_logic`)
- **Mục tiêu**: Mô phỏng giỏ hàng & sản phẩm với luồng dữ liệu 4 tầng chuẩn Clean Code: Model → Data Source → Service → UI.
- **Cấu trúc**:
  ```
  quick_shop_logic/
  ├── lib/
  │   ├── models/
  │   │   └── product.dart          # Class Product với Named Parameters
  │   ├── data/
  │   │   └── data_source.dart      # rawProducts (dữ liệu giả lập)
  │   ├── services/
  │   │   └── product_service.dart  # getAllProducts, filterByMaxPrice, handleAddToCart, calculateTotalPrice
  │   └── main.dart                 # QuickShopPage (ListView, Card, onTap callback)
  ```
- **Tính năng & Bài tập mở rộng đã hoàn thành**:
  - [x] Lọc sản phẩm giá rẻ (`price < 100$`) bằng `.where()`.
  - [x] Biến đổi `List<Product>` thành `List<Widget>` bằng `.map()`.
  - [x] Callback khi bấm mua: in log thông tin sản phẩm và hiển thị SnackBar.
  - [x] Bài tập mở rộng Level 1: Tách hàm xử lý `_handleProductTap` bên ngoài `build()`.
  - [x] Bài tập mở rộng Level 2: Tính tổng tiền danh sách hiển thị bằng vòng lặp và hiển thị/in ra console.
  - [x] Bài tập mở rộng Level 3: Bổ sung thuộc tính `imageUrl` và hiển thị ảnh bằng `Image.network`.
  - [x] Nút toggle chuyển đổi nhanh giữa *Sản phẩm giá rẻ (< 100$)* và *Tất cả sản phẩm*.

---

## 🚀 Hướng dẫn chạy thử nghiệm

### Chạy Student Manager:
```bash
cd Exercises/Slot3/student_manager
flutter run
```

### Chạy Quick Shop:
```bash
cd Exercises/Slot3/quick_shop_logic
flutter run
```
