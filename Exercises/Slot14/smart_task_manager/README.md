# Smart Task Manager (Basic Persistence - SharedPreferences)

Phần 1 trong chuỗi bài tập Offline-first: Lưu trữ dữ liệu tác vụ cục bộ sử dụng `shared_preferences` và JSON serialization.

## Chức năng
- **Create**: Thêm task mới.
- **Read**: Tự động load danh sách task từ SharedPreferences khi khởi động ứng dụng.
- **Update**: Sửa tiêu đề task qua Dialog, toggle trạng thái hoàn thành / chưa hoàn thành (gạch ngang tiêu đề).
- **Delete**: Xóa từng task hoặc xóa toàn bộ danh sách (Clear All) có hộp thoại xác nhận.
- **Persistence**: Tự động serialize `List<Task>` thành JSON string và lưu vào SharedPreferences sau mỗi thao tác.

## Cấu trúc thư mục
```text
lib/
├── main.dart
├── models/
│   └── task.dart
├── services/
│   └── preferences_service.dart
└── screens/
    └── home_screen.dart
```

## Chạy ứng dụng
```bash
flutter run
```

## Chạy kiểm thử
```bash
flutter test
```
