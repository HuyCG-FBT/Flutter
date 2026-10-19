# Smart Registration App 🧾

Ứng dụng Flutter hoàn chỉnh mô phỏng quy trình đăng ký tài khoản (Form Validation, Async Submit Flow, Error Handling & Navigation) trong chương trình PRM393 - **Slot 11**.

---

## 1. Cấu trúc thư mục dự án

```text
lib/
├── main.dart                          # Khởi chạy SmartRegistrationApp
├── models/
│   └── user_model.dart                # Model dữ liệu người dùng (tách biệt data khỏi UI)
├── screens/
│   ├── register_screen.dart           # Màn hình Form đăng ký (StatefulWidget, Form + GlobalKey, Controllers)
│   └── success_screen.dart            # Màn hình thông báo đăng ký thành công
├── services/
│   └── fake_auth_service.dart         # Service giả lập API đăng ký (Future.delayed 2s, throw error với test@error.com)
└── utils/
    └── validators.dart                # Bộ hàm validate tĩnh (required, email regex, password min length)
test/
├── validators_test.dart               # Unit tests kiểm thử độc lập các hàm validate
└── widget_test.dart                   # Widget tests kiểm thử giao diện, validation, error SnackBar, success flow
```

---

## 2. Các tính năng chính & Kỹ thuật triển khai

### A. Quản lý Form với `Form` & `GlobalKey<FormState>`
- Sử dụng `_formKey = GlobalKey<FormState>()` để truy cập trạng thái form và gọi hàm xác thực toàn bộ input:
  ```dart
  if (!_formKey.currentState!.validate()) return;
  ```
- Quản lý giá trị nhập liệu bằng 4 `TextEditingController`:
  - `_nameController`: Họ và tên
  - `_emailController`: Email
  - `_passwordController`: Mật khẩu
  - `_confirmController`: Xác nhận mật khẩu
- Đảm bảo giải phóng bộ nhớ trong phương thức `dispose()`:
  ```dart
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }
  ```

### B. Bộ quy tắc xác thực (Validators)
- **Họ tên**: Bắt buộc nhập, không được để trống hoặc chỉ có khoảng trắng (`value.trim().isEmpty`).
- **Email**: Định dạng chuẩn qua Regular Expression (`r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'`).
- **Mật khẩu**: Độ dài tối thiểu 6 ký tự (`value.length >= 6`).
- **Xác nhận mật khẩu**: Khớp chính xác với mật khẩu đã nhập (`_passwordController.text == _confirmController.text`).

### C. Quy trình Submit & Xử lý Bất đồng bộ (Submit Flow)
1. **Kiểm tra hợp lệ**: Chạy validator qua `_formKey.currentState!.validate()`.
2. **Kiểm tra khớp mật khẩu**: Nếu không khớp, hiển thị `SnackBar("Passwords do not match")`.
3. **Kích hoạt Loading**: Thiết lập `_isLoading = true` để hiển thị `CircularProgressIndicator` và vô hiệu hóa nút đăng ký nhằm **chống double submit**.
4. **Gọi API giả lập**: Gọi `FakeAuthService().register(user)` (chờ 2 giây):
   - Nếu `email == "test@error.com"`: Bắn lỗi ngoại lệ `Exception("Email already exists")`.
5. **Điều hướng an toàn**:
   - Sử dụng `if (!mounted) return;` trước khi thực hiện điều hướng để tránh lỗi truy cập context sau khi widget đã bị huỷ.
   - Dùng `Navigator.pushReplacement(...)` đưa người dùng sang `SuccessScreen` và dọn dẹp màn hình đăng ký khỏi back stack.
6. **Bắt lỗi & Dọn dẹp trạng thái**: Bắt `catch (e)` hiển thị SnackBar lỗi và luôn trả `_isLoading = false` trong khối `finally` nếu widget còn `mounted`.

---

## 3. Bảng kịch bản kiểm thử (Test Cases)

| Kịch bản | Dữ liệu đầu vào | Kết quả mong đợi |
| :--- | :--- | :--- |
| **Bỏ trống các trường** | Bấm Register khi chưa nhập gì | Hiển thị lỗi đỏ dưới cả 4 trường |
| **Email sai định dạng** | `invalid-email` hoặc `user@` | Báo lỗi `Invalid email format` |
| **Password quá ngắn** | Dưới 6 ký tự | Báo lỗi `Password must be at least 6 characters` |
| **Confirm password lệch** | Mật khẩu và xác nhận không giống nhau | Hiện SnackBar `Passwords do not match` |
| **Email mô phỏng lỗi API** | Email là `test@error.com` | Hiện SnackBar lỗi từ service (`Email already exists`) |
| **Đăng ký thành công** | Dữ liệu đầy đủ và hợp lệ | Hiện loading 2s -> Chuyển sang `SuccessScreen` |
| **Chống Double Submit** | Bấm Register liên tục | Nút Register bị vô hiệu hóa khi `_isLoading = true` |

---

## 4. Các lỗi phổ biến & Kinh nghiệm rút ra

1. **Quên dispose controller**: Dẫn đến rò rỉ bộ nhớ (Memory Leak) khi người dùng thoát màn hình.
2. **Không kiểm tra `mounted` sau `await`**: Gây crash hoặc cảnh báo framework khi cố gọi `setState()` hoặc `Navigator` trên widget unmounted.
3. **Không disable nút khi loading**: Khiến người dùng bấm nhiều lần, gửi nhiều request trùng lặp (Double Submit).
4. **Dùng controller làm source-of-truth**: Nên chuyển dữ liệu sang `UserModel` trước khi truyền vào business logic/service layer.

---

## 5. Hướng dẫn chạy & Kiểm thử

1. Chuyển vào thư mục:
   ```bash
   cd Exercises/Slot11/smart_registration_app
   ```
2. Tải dependencies:
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
