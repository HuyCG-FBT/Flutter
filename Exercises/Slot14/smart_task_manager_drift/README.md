# Smart Task Manager (Drift Persistence - SQLite ORM)

Phần 4 trong chuỗi bài tập Offline-first: Lưu trữ dữ liệu SQLite hướng đối tượng bằng thư viện ORM `drift` và `drift_flutter`, sinh mã type-safe thông qua `build_runner`.

## Chức năng
- **Type-safe Dart Tables**: Khai báo bảng `Tasks` hoàn toàn bằng ngôn ngữ Dart (`text()`, `boolean()`, `integer()`, `primaryKey`).
- **Code Generation**: Tự động sinh `app_database.g.dart` tạo sẵn class `Task` và companion `TasksCompanion`.
- **DAO Pattern**:
  - `insertTask`: Thêm task mới với chế độ `InsertMode.insertOrReplace`.
  - `getAllTasks`: Truy vấn lấy danh sách sắp xếp theo `createdAt DESC`.
  - `toggleDone`: Đảo trạng thái `isDone` trực tiếp trong database.
  - `updateTitle`: Cập nhật tiêu đề task.
  - `deleteTask`: Xóa theo `id`.
  - `deleteAll`: Xóa toàn bộ task.
  - `watchAllTasks`: Hỗ trợ Stream tự động phát dữ liệu khi database thay đổi (reactive).

## Cấu trúc thư mục
```text
lib/
├── main.dart
├── db/
│   ├── app_database.dart
│   ├── app_database.g.dart
│   └── tables.dart
├── repositories/
│   └── task_dao.dart
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
