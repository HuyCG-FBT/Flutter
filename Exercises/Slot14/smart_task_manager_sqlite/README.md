# Smart Task Manager (SQLite Persistence - sqflite)

Phần 2 trong chuỗi bài tập Offline-first: Lưu trữ dữ liệu cấu trúc bảng bằng SQLite thông qua thư viện `sqflite` và `path`.

## Chức năng
- **Bảng dữ liệu**:
  ```sql
  CREATE TABLE tasks(
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    is_done INTEGER NOT NULL,
    created_at INTEGER NOT NULL
  );
  ```
- **Mapping**: Chuyển đổi giữa Dart `bool` (`isDone`) và SQLite `INTEGER` (0/1).
- **CRUD đầy đủ**:
  - `insertTask`: Chèn dòng mới vào bảng `tasks`.
  - `getAllTasks`: Truy vấn sắp xếp `ORDER BY created_at DESC`.
  - `updateTask`: Cập nhật tiêu đề hoặc trạng thái hoàn thành.
  - `deleteTask`: Xóa dòng theo `id`.
  - `deleteAll`: Xóa toàn bộ dữ liệu.
- **Persistence**: Dữ liệu lưu trong file database SQLite (`smart_task_manager.db`) không phụ thuộc internet hay RAM.

## Cấu trúc thư mục
```text
lib/
├── main.dart
├── models/
│   └── task.dart
├── db/
│   └── app_database.dart
├── repositories/
│   └── task_repository.dart
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
