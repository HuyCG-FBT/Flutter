# Slot 16: Auth Session Demo App 🔐

## 1. Tổng quan dự án
Ứng dụng minh họa quy trình xác thực người dùng, lưu trữ phiên đăng nhập bền vững và bảo vệ điều hướng màn hình (Guarded Routes) trong Flutter:
- **Login screen**: Giao diện đăng nhập với Form validation (kiểm tra username rỗng, password < 4 ký tự).
- **Mock authentication**: Xác thực tài khoản giả lập (`admin` / `1234`).
- **Session persistence**: Lưu trạng thái đăng nhập vào bộ nhớ thiết bị bằng thư viện `shared_preferences`.
- **Guarded routes**: Màn hình Profile được bảo vệ qua `AuthGuard` và `onGenerateRoute`, nếu chưa login sẽ tự động chuyển hướng về `/login`.
- **Logout flow**: Xóa session, điều hướng về màn hình Login bằng `pushReplacementNamed` để ngăn user quay lại màn hình protected.

---

## 2. Cấu trúc thư mục
```plaintext
lib/
├── main.dart                  # Cấu hình routes, guarded route với FutureBuilder & kiểm tra session khi mở app
├── screens/
│   ├── login_screen.dart      # Màn hình đăng nhập & form validation
│   ├── dashboard_screen.dart  # Màn hình chính sau khi đăng nhập thành công
│   └── profile_screen.dart    # Màn hình thông tin cá nhân & nút Logout
├── services/
│   ├── auth_service.dart      # Xử lý logic đăng nhập (Mock credentials)
│   └── session_service.dart   # Quản lý session qua SharedPreferences
└── guards/
    └── auth_guard.dart        # Route guard kiểm tra trạng thái login
```

---

## 3. Quy trình xác thực và luồng dữ liệu (Data & Auth Flow)
```plaintext
Mở App -> SessionService.isLoggedIn() -> initialRoute: /dashboard hoặc /login

User đăng nhập -> Form validate -> AuthService.login("admin", "1234")
   ├── Thành công -> SessionService.saveSession(true) -> Navigator.pushReplacementNamed("/dashboard")
   └── Thất bại   -> Hiển thị SnackBar "Login failed"

Từ Dashboard -> Bấm "Open Profile" -> onGenerateRoute("/profile")
   └── FutureBuilder gọi AuthGuard.check()
         ├── Đã login   -> Hiển thị ProfileScreen
         └── Chưa login -> Redirecting to Login... -> Navigator.pushReplacementNamed("/login")

Từ Profile -> Bấm "Logout" -> SessionService.clearSession() -> Navigator.pushReplacementNamed("/login")
```

---

## 4. Hướng dẫn chạy thử nghiệm
```bash
cd Exercises/Slot16/auth_session_app
flutter pub get
flutter run
```
