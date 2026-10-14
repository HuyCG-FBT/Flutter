# Simple Product Dashboard App 📱

Ứng dụng demo rèn luyện tư duy **Flex Layout**, **GridView**, **Stack (Overlay Badge)** và cơ chế **Navigation / Deep Linking** trong Flutter (PRM393 - BÀI TẬP TỔNG HỢP 1).

---

## 1. Cấu trúc dự án

```text
lib/
├── main.dart                          # Entrypoint, khai báo ThemeData & Named Routes
├── screens/
│   ├── dashboard_screen.dart          # Màn hình chính (Column, Expanded, Navigation button)
│   └── product_grid_screen.dart       # Màn hình danh sách sản phẩm (GridView.builder)
└── widgets/
    ├── dashboard_header.dart          # Header chào mừng (Row) + Chuông thông báo có badge (Stack + Positioned)
    └── product_card.dart              # Card sản phẩm dạng lưới (Card, Column, Expanded image placeholder)
test/
└── widget_test.dart                   # Test kiểm thử rendering giao diện & luồng chuyển màn hình
```

---

## 2. Kiến thức & Quyết định Layout

### A. Flex Layout (Column, Row, Expanded)
- **`Column`** (Trục chính: Dọc `mainAxis`, Trục phụ: Ngang `crossAxis`): Bố trí phần Header cố định ở trên và phần nội dung chiếm toàn bộ khoảng trống còn lại.
- **`Expanded`**: Bắt buộc bọc quanh phần nội dung trung tâm (`Center`) bên trong `Column` để tránh lỗi kinh điển `RenderFlex overflowed`. Widget này báo cho Flutter biết nó sẽ linh hoạt chiếm toàn bộ không gian còn trống.
- **`Row`**: Dùng trong `DashboardHeader` để chia layout ngang (bên trái là lời chào, bên phải là icon thông báo) với `mainAxisAlignment: MainAxisAlignment.spaceBetween`.

### B. Stack & Positioned (Badge thông báo)
- **Mục đích**: `Stack` được thiết kế để xếp chồng các lớp UI (overlay), không dùng để dựng layout tuần tự chính.
- **Badge thông báo**: Dùng `Stack(clipBehavior: Clip.none)` kết hợp với `Positioned(right: -2, top: -2)` để đặt chấm đỏ nhỏ (`CircleAvatar`) nổi bật ở góc trên bên phải của biểu tượng chuông `Icons.notifications` mà không bị viền cắt xén.

### C. GridView.builder vs Column + Row
- Khi hiển thị danh sách nhiều item dạng lưới (2 cột):
  - **Không dùng `Column + Row`** vì không hỗ trợ cuộn (scroll) tự nhiên, dễ vỡ giao diện trên màn hình nhỏ hoặc khi dữ liệu dài.
  - **`GridView.builder`**: Tối ưu hiệu năng bộ nhớ (lazy loading - chỉ render các item hiển thị trên màn hình) thông qua `SliverGridDelegateWithFixedCrossAxisCount`.

---

## 3. Điều hướng (Navigation)

### Named Routes
App sử dụng bảng định tuyến tĩnh khai báo trong `MaterialApp`:
```dart
initialRoute: '/',
routes: {
  '/': (context) => const DashboardScreen(),
  '/products': (context) => const ProductGridScreen(),
},
```
Khi người dùng bấm nút:
```dart
Navigator.pushNamed(context, '/products');
```
Ưu điểm của Named Routes:
- Tách biệt logic điều hướng khỏi việc khởi tạo widget trực tiếp (`MaterialPageRoute`).
- Tên route dạng URL path (`/`, `/products`) tương thích tự nhiên với cấu trúc Deep Link từ bên ngoài hệ điều hành.

---

## 4. Nhận thức về iOS URL Scheme (Deep Linking)

### Khái niệm
- **Deep Link** cho phép hệ điều hành (iOS / Android) mở trực tiếp một màn hình cụ thể trong ứng dụng từ bên ngoài (trình duyệt Safari, tin nhắn, email, thông báo đẩy).
- Ví dụ URL Scheme tuỳ chỉnh:
  ```text
  myapp://products
  ```

### Luồng hoạt động:
1. Người dùng bấm vào liên kết `myapp://products` trên Safari hoặc một ứng dụng khác.
2. Hệ điều hành nhận diện scheme `myapp://` thuộc về ứng dụng đã đăng ký (thông qua cấu hình `CFBundleURLTypes` trong file `ios/Runner/Info.plist`).
3. Hệ điều hành khởi chạy app hoặc đưa app lên foreground, truyền URL vào callback native (`SceneDelegate` trên iOS hoặc `Intent` trên Android).
4. Flutter app (thông qua các thư viện như `app_links` hoặc `uni_links`) bắt lấy URI:
   ```dart
   final path = uri.path; // '/products'
   Navigator.pushNamed(context, path);
   ```
5. App tự động chuyển tới màn hình `ProductGridScreen` tương ứng.

---

## 5. Hướng dẫn chạy & Kiểm thử

1. Chuyển vào thư mục:
   ```bash
   cd Exercises/Slot9/simple_dashboard_app
   ```
2. Cài đặt dependencies:
   ```bash
   flutter pub get
   ```
3. Chạy kiểm tra tĩnh (Static Analysis):
   ```bash
   flutter analyze
   ```
4. Chạy bộ kiểm thử tự động (Widget Tests):
   ```bash
   flutter test
   ```
5. Khởi chạy ứng dụng:
   ```bash
   flutter run
   ```
