# Slot 17: Auth Session Demo App 🔐

## 1. Tóm tắt dự án
Ứng dụng thực hành kiến trúc bảo mật phiên làm việc và bảo vệ các tuyến đường điều hướng trong Flutter:
- **Login screen**: Form đăng nhập có xác thực hợp lệ (validation: username rỗng, password < 4 ký tự).
- **Mock authentication**: Xác thực tài khoản giả lập (`admin` / `1234`).
- **Session persistence**: Lưu trữ trạng thái phiên đăng nhập qua `shared_preferences`.
- **Guarded routes**: Tuyến đường `/profile` được bảo vệ bằng `AuthGuard` qua `onGenerateRoute`, nếu chưa đăng nhập sẽ chuyển hướng người dùng về `/login`.
- **Logout flow**: Xóa session và `pushReplacementNamed` về `/login` (không cho back lại màn hình protected).

---

## 2. Cấu trúc thư mục
```plaintext
lib/
├── main.dart                  # Cấu hình routes, guarded route với FutureBuilder & kiểm tra session khi mở app
├── screens/
│   ├── login_screen.dart      # Màn hình đăng nhập & form validation
│   ├── dashboard_screen.dart  # Màn hình Dashboard sau khi login
│   └── profile_screen.dart    # Màn hình Profile & nút Logout
├── services/
│   ├── auth_service.dart      # Xử lý logic đăng nhập (Mock credentials)
│   └── session_service.dart   # Quản lý session qua SharedPreferences
└── guards/
    └── auth_guard.dart        # Route guard kiểm tra trạng thái login
```

---

## 3. Luồng dữ liệu & Xác thực (Auth Flow)
```plaintext
Khởi động App -> SessionService.isLoggedIn() -> initialRoute: /dashboard hoặc /login

Đăng nhập -> Form Validate -> AuthService.login("admin", "1234")
   ├── Thành công -> SessionService.saveSession(true) -> Navigator.pushReplacementNamed("/dashboard")
   └── Thất bại   -> SnackBar("Login failed")

Từ Dashboard -> Nhấn "Open Profile" -> onGenerateRoute("/profile")
   └── FutureBuilder gọi AuthGuard.check()
         ├── Đã đăng nhập   -> Hiển thị ProfileScreen
         └── Chưa đăng nhập -> Hiển thị "Redirecting to Login..." -> Navigator.pushReplacementNamed("/login")

Từ Profile -> Nhấn "Logout" -> SessionService.clearSession() -> Navigator.pushReplacementNamed("/login")
```

---

## 4. Hướng dẫn chạy thử nghiệm
```bash
cd Exercises/Slot17/auth_session_app
flutter pub get
flutter run
```
