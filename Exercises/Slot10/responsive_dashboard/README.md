# Responsive Dashboard App 📱💻

Ứng dụng demo thực hành tư duy **Responsive Design**, phân biệt **`MediaQuery` vs `LayoutBuilder`**, và kỹ thuật **Responsive Refactor** tránh hard-code kích thước trong Flutter (PRM393 - Bài tập tổng hợp Responsive).

---

## 1. Cấu trúc dự án

```text
lib/
├── main.dart                          # Khởi chạy ResponsiveDashboardApp
├── screens/
│   └── dashboard_screen.dart          # Màn hình chính (MediaQuery cho spacing/font, LayoutBuilder cho Summary)
└── widgets/
    ├── summary_card.dart              # Card thống kê không set width/height cố định, tự co giãn
    └── responsive_grid.dart          # Grid sản phẩm tự đổi số cột (2, 3, 4) theo constraints.maxWidth
test/
└── widget_test.dart                   # Bộ test tự động kiểm thử 3 kích thước màn hình (Mobile, Tablet, Desktop)
```

---

## 2. Lộ trình Tư duy & Các bước thực hiện

### 📍 Bước 1 & 2: Vấn đề với UI Cố định (Fixed UI - Cố tình sai)
- **Sai lầm thường gặp**: Hard-code kích thước pixel cố định:
  ```dart
  Container(width: 350, height: 120, ...)
  Container(width: 160, height: 120, ...)
  GridView.count(crossAxisCount: 3, ...)
  ```
- **Hậu quả**:
  - Trên màn hình nhỏ (360px): Bị tràn màn hình (`RenderFlex overflowed`), 3 cột GridView bị co dúm không đọc được chữ.
  - Trên Tablet / Desktop: Card bị nhỏ xíu, bố cục lệch, không tận dụng được không gian hiển thị.

### 📍 Bước 3: Phân tích nguyên tắc Constraint-based của Flutter
> *"Constraints go down. Sizes go up. Parent sets position."*
- Widget con không tự quyết định kích thước tuyệt đối theo pixel mà phải tuân thủ giới hạn (`minWidth`, `maxWidth`, `minHeight`, `maxHeight`) do widget cha truyền xuống.

### 📍 Bước 4: Áp dụng `MediaQuery` cho Spacing & Typography
- **Mục đích**: Điều chỉnh padding và kích thước chữ mềm dẻo theo tỉ lệ chiều rộng màn hình thiết bị, kết hợp `.clamp(min, max)` để chữ không quá bé hoặc quá khổng lồ:
  ```dart
  final screenWidth = MediaQuery.of(context).size.width;
  final horizontalPadding = screenWidth * 0.04; // 4% màn hình
  final headerFontSize = (screenWidth * 0.06).clamp(20.0, 32.0);
  ```

### 📍 Bước 5 & 6: Áp dụng `LayoutBuilder` & Responsive Refactor Summary Cards
- **Refactor `SummaryCard`**:
  - Tuyệt đối **không đặt `width` hay `height` cố định** trong `SummaryCard`.
  - Để widget cha quyết định kích thước:
    - Khi đặt trong `Row`: Bọc từng card bằng `Expanded(child: card)` để các card chia đều chiều ngang.
    - Khi đặt trong `Column`: Dùng `crossAxisAlignment: CrossAxisAlignment.stretch` để các card tự kéo dãn 100% chiều ngang.
- **Quyết định bố cục theo Breakpoint (600px)**:
  ```dart
  LayoutBuilder(
    builder: (context, constraints) {
      final isNarrow = constraints.maxWidth < 600;
      if (isNarrow) {
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [...]);
      } else {
        return Row(children: [Expanded(child: cards[0]), ...]);
      }
    },
  )
  ```

### 📍 Bước 7: GridView Responsive theo Chiều rộng (`ResponsiveProductGrid`)
- Sử dụng `LayoutBuilder` để lấy `constraints.maxWidth` của riêng vùng Grid (thay vì toàn màn hình):
  - **Dưới 600px (Mobile)**: `crossAxisCount = 2` cột.
  - **Từ 600px - 900px (Tablet)**: `crossAxisCount = 3` cột.
  - **Trên 900px (Desktop)**: `crossAxisCount = 4` cột.
- Sử dụng `shrinkWrap: true` và `physics: const NeverScrollableScrollPhysics()` vì GridView nằm trong `SingleChildScrollView` của Dashboard.

### 📍 Bước 8: Kiểm soát Text Overflow
- Luôn kiểm soát các nội dung chữ dài bằng `maxLines` và `overflow: TextOverflow.ellipsis` kết hợp `Spacer()` để các thẻ có cùng chiều cao đồng đều.

---

## 3. So sánh `MediaQuery` vs `LayoutBuilder`

| Tiêu chí | `MediaQuery` | `LayoutBuilder` |
| :--- | :--- | :--- |
| **Phạm vi thông tin** | Kích thước toàn bộ cửa sổ / màn hình thiết bị | Giới hạn kích thước (`BoxConstraints`) của widget cha cấp cho widget con |
| **Trường hợp sử dụng** | Padding màn hình, Safe area, Orientation (xoay màn hình), Text scaling | Quyết định chuyển đổi Layout (Row <-> Column), số cột GridView, bố cục theo vùng chứa |
| **Tính module hóa** | Khó tái sử dụng widget con độc lập vì phụ thuộc toàn màn hình | Rất cao, widget có thể đặt ở bất kỳ đâu (Sidebar, Split-view, Dialog) mà vẫn tự thích ứng |

---

## 4. Hướng dẫn chạy & Kiểm thử

1. Chuyển vào thư mục:
   ```bash
   cd Exercises/Slot10/responsive_dashboard
   ```
2. Lấy dependencies:
   ```bash
   flutter pub get
   ```
3. Phân tích tĩnh (Static Analysis):
   ```bash
   flutter analyze
   ```
4. Chạy kiểm thử đa thiết bị (Automated Widget Tests):
   ```bash
   flutter test
   ```
5. Chạy ứng dụng:
   ```bash
   flutter run
   ```
