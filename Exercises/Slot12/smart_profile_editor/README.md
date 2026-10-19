# Smart Profile Editor App 👤📝

Ứng dụng Flutter hoàn chỉnh chỉnh sửa hồ sơ người dùng kết hợp **REST API (GET/PUT)**, **Lưu nháp tự động (Draft với SharedPreferences)**, **Debounce 400ms**, **Form Validation & Keyboard UX** trong chương trình PRM393 - **Slot 12**.

---

## 1. Cấu trúc thư mục dự án

```text
lib/
├── main.dart                          # Khởi chạy SmartProfileEditorApp
├── models/
│   └── profile_model.dart             # Model Profile (fromJson, toJson, copyWith, operator ==, hashCode)
├── services/
│   ├── api_service.dart               # Tầng mạng gọi GET / PUT tới JSONPlaceholder, Timeout 10s, ApiException
│   └── draft_service.dart             # Tầng lưu trữ nháp cục bộ qua SharedPreferences
├── repositories/
│   └── profile_repository.dart        # Tầng Repository trung gian giữa UI và Data Source
└── screens/
    └── profile_screen.dart            # Màn hình chính (Bootstrap, Form, FocusNode, Debounce Draft, PopScope, Submit)
test/
├── model_test.dart                    # Unit tests kiểm thử Profile Model
├── draft_service_test.dart            # Unit tests kiểm thử DraftService với Mock SharedPreferences
└── widget_test.dart                   # Widget tests kiểm thử UI, validation, submit và error retry
```

---

## 2. Các chức năng chính & Kỹ thuật triển khai

### A. Tích hợp REST API (GET / PUT) & Xử lý Ngoại lệ
- **GET Profile**: Gọi `https://jsonplaceholder.typicode.com/users/1` lấy thông tin ban đầu.
- **PUT Update**: Gửi dữ liệu cập nhật dưới dạng JSON với headers `Content-Type: application/json`.
- **Timeout & Status Code chuẩn**:
  - Gắn `.timeout(const Duration(seconds: 10))` phòng ngừa treo kết nối mạng.
  - Kiểm tra dải mã thành công HTTP `statusCode >= 200 && statusCode < 300`.
  - Tách loại lỗi rõ ràng với lớp `ApiException(statusCode, message)`.

### B. Cơ chế Lưu nháp tự động (Draft Auto-Save & Debounce)
- **Ưu tiên nạp dữ liệu (Bootstrap Flow)**:
  1. Khi mở app, `_bootstrap()` kiểm tra bản nháp từ `DraftService.loadDraft()` trước.
  2. Nếu có bản nháp chưa lưu: Điền ngay vào Form để người dùng tiếp tục chỉnh sửa mà không bị mất dữ liệu.
  3. Nếu không có bản nháp: Gọi `ProfileRepository.getProfile()` tải từ server.
- **Debounce 400ms**: Mỗi khi người dùng gõ phím (`onChanged`), `Timer` 400ms được reset. Chỉ khi người dùng ngừng gõ quá 400ms thì mới ghi xuống `SharedPreferences`, tránh hiện tượng ghi đĩa liên tục gây suy giảm hiệu năng.
- **Xóa nháp khi submit**: Khi cập nhật thành công lên server, gọi `DraftService.clearDraft()` để lần mở sau app sẽ lấy dữ liệu mới nhất từ server.

### C. Trải nghiệm Bàn phím & Focus Management
- Mỗi ô nhập liệu được gắn một `FocusNode` riêng (`_nameFocus`, `_emailFocus`, `_phoneFocus`).
- `textInputAction: TextInputAction.next` ở các ô trên giúp bấm phím Next trên bàn phím ảo sẽ tự động nhảy tiêu điểm sang ô tiếp theo.
- `textInputAction: TextInputAction.done` ở ô cuối cùng sẽ trực tiếp kích hoạt gửi form (`_submit()`).
- Bọc toàn màn hình bằng `GestureDetector(onTap: () => FocusScope.of(context).unfocus())` cho phép người dùng chạm ra ngoài để đóng bàn phím.

### D. Dirty State & Xác nhận rời trang (PopScope)
- So sánh `_currentProfile()` với `_originalProfile` thông qua toán tử so sánh `operator ==` để xác định form đã bị chỉnh sửa hay chưa (`_isDirty`).
- Sử dụng widget hiện đại `PopScope(canPop: !_isDirty)`: Nếu người dùng đã sửa mà chưa bấm lưu, app sẽ hiển thị hộp thoại cảnh báo: *"Bạn có thay đổi chưa lưu. Bạn có chắc muốn thoát không?"*.

---

## 3. Bảng kịch bản kiểm thử (Test Cases)

| Kịch bản | Thao tác | Kết quả mong đợi |
| :--- | :--- | :--- |
| **Nạp dữ liệu lần đầu** | Mở app khi chưa có draft | Gọi API GET -> Điền dữ liệu `name`, `email`, `phone` |
| **Nạp bản nháp** | Đã có draft trong máy | Điền dữ liệu từ draft, không gọi API đè lên |
| **Validate bắt buộc** | Xóa trắng Họ tên/Email/SĐT | Báo đỏ `Không được để trống` |
| **Validate Email** | Nhập `invalid-email` | Báo đỏ `Email không hợp lệ (ví dụ: a@b.com)` |
| **Validate Số điện thoại** | Nhập dưới 8 ký tự | Báo đỏ `SĐT không hợp lệ (ít nhất 8 ký tự số)` |
| **Lưu thành công** | Bấm `Lưu cập nhật` | Hiện loading -> Gọi PUT -> Xóa draft -> Báo SnackBar `Cập nhật thành công` |
| **Lỗi mạng & Thử lại** | Server trả lỗi khi tải | Hiện màn hình báo lỗi màu đỏ kèm nút `Thử lại` |

---

## 4. Hướng dẫn chạy & Kiểm thử

1. Chuyển vào thư mục:
   ```bash
   cd Exercises/Slot12/smart_profile_editor
   ```
2. Cài đặt dependencies:
   ```bash
   flutter pub get
   ```
3. Phân tích tĩnh (Static Analysis):
   ```bash
   flutter analyze
   ```
4. Chạy toàn bộ Unit & Widget Tests:
   ```bash
   flutter test
   ```
5. Khởi chạy ứng dụng:
   ```bash
   flutter run
   ```
