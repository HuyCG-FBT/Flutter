# Slot 14: Smart Task Manager (Offline-first Persistence Suite)

Bộ bài tập tổng hợp về lưu trữ dữ liệu offline (Local Persistence) trên Flutter qua 4 cấp độ kỹ thuật:

---

## 📑 Danh mục các dự án con

| Dự án | Công nghệ | Mô hình | Đặc điểm chính |
|---|---|---|---|
| [`smart_task_manager`](smart_task_manager/) | `shared_preferences` | Key-Value / JSON | Lưu danh sách dạng JSON String, phù hợp config, token, list nhỏ |
| [`smart_task_manager_sqlite`](smart_task_manager_sqlite/) | `sqflite` + `path` | Relational SQLite | Lưu theo dòng (row-level), ánh xạ bool sang int (0/1), câu lệnh SQL trực tiếp |
| [`smart_task_manager_hive`](smart_task_manager_hive/) | `hive` + `hive_flutter` | NoSQL Box | Truy xuất dữ liệu cực nhanh, không cần SQL hay JSON encode thủ công |
| [`smart_task_manager_drift`](smart_task_manager_drift/) | `drift` + `build_runner` | SQLite ORM | Khai báo bảng bằng code Dart thuần, sinh mã tự động, type-safe, hỗ trợ Stream watch |

---

## 🏗️ Cấu trúc thư mục Slot14

```text
Exercises/Slot14/
├── smart_task_manager/          # Phần 1: SharedPreferences
│   ├── lib/
│   │   ├── models/task.dart
│   │   ├── services/preferences_service.dart
│   │   ├── screens/home_screen.dart
│   │   └── main.dart
│   └── test/widget_test.dart
├── smart_task_manager_sqlite/   # Phần 2: sqflite
│   ├── lib/
│   │   ├── models/task.dart
│   │   ├── db/app_database.dart
│   │   ├── repositories/task_repository.dart
│   │   ├── screens/home_screen.dart
│   │   └── main.dart
│   └── test/widget_test.dart
├── smart_task_manager_hive/     # Phần 3: Hive
│   ├── lib/
│   │   ├── models/task.dart
│   │   ├── services/hive_service.dart
│   │   ├── screens/home_screen.dart
│   │   └── main.dart
│   └── test/widget_test.dart
└── smart_task_manager_drift/    # Phần 4: Drift ORM
    ├── lib/
    │   ├── db/tables.dart
    │   ├── db/app_database.dart
    │   ├── repositories/task_dao.dart
    │   ├── screens/home_screen.dart
    │   └── main.dart
    └── test/widget_test.dart
```

---

## 🧪 Kiểm thử và Phân tích tĩnh

Tất cả 4 dự án con đều đạt tiêu chuẩn:
- `flutter analyze`: **No issues found!**
- `flutter test`: **100% Passed**.
