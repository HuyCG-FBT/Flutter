# Smart Task Manager (Hive Persistence - NoSQL)

Phần 3 trong chuỗi bài tập Offline-first: Lưu trữ dữ liệu NoSQL cục bộ tốc độ cao với thư viện `hive` và `hive_flutter`.

## Chức năng
- **NoSQL Box**: Khởi tạo `Hive.initFlutter()` và mở Box `taskBox` tại điểm bắt đầu ứng dụng trong `main()`.
- **Fast Local Storage**: Đọc dữ liệu đồng bộ nhanh chóng thông qua `_box.get()` và ghi bất đồng bộ qua `_box.put()`.
- **CRUD đầy đủ**:
  - `_addTask`: Thêm task mới với timestamp `createdAt`.
  - `_toggleDone`: Đảo trạng thái hoàn thành và lưu xuống Box.
  - `_editTaskDialog`: Hộp thoại chỉnh sửa tên task.
  - `_deleteTask`: Xóa task khỏi Box.
  - `_clearAllDialog`: Xóa toàn bộ task trong Box với hộp thoại xác nhận.
- **Persistence**: Đóng/mở app dữ liệu vẫn được lưu trữ nguyên vẹn không cần internet.

## Cấu trúc thư mục
```text
lib/
├── main.dart
├── models/
│   └── task.dart
├── services/
│   └── hive_service.dart
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
