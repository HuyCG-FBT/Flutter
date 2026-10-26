# Slot 15: Smart Todo Backup App 📝

## 1. Tổng quan bài học
- **Persistent List Rendering**: Danh sách Todo được render bằng `ListView.builder` dựa trên `List<Todo>`.
- **Sync-Up Concept**: `setState()` là "nút Sync" kích hoạt hàm `build()` vẽ lại UI khi dữ liệu thay đổi (thêm việc, hoàn thành việc).
- **JSON Serialization**: Sử dụng `toJson()` / `fromJson()` để chuẩn hóa dữ liệu Object $\leftrightarrow$ Map.
- **JSON Backup**: Dùng `jsonEncode` để xuất danh sách Todo thành chuỗi JSON backup (in ra Console).

---

## 2. Cấu trúc thư mục
```plaintext
todo_backup_app/
├── lib/
│   ├── models/
│   │   └── todo.dart           # Model Todo (toJson, fromJson)
│   ├── services/
│   │   └── json_service.dart   # Service export/import JSON
│   ├── widgets/
│   │   └── todo_item.dart      # TodoItem widget riêng biệt
│   ├── screens/
│   │   └── home_screen.dart    # HomeScreen (StatefulWidget, ListView.builder, setState)
│   └── main.dart               # Entrypoint ứng dụng
└── test/
    └── widget_test.dart        # Kiểm thử unit và widget
```

---

## 3. Data Flow
```plaintext
User nhập TextField
       ↓
   Nhấn "+"
       ↓
addTodo() thêm vào List<Todo>
       ↓
   setState()
       ↓
Flutter gọi lại build()
       ↓
ListView.builder render theo todos.length
       ↓
Nhấn Save → JsonService.exportTodos(todos)
       ↓
jsonEncode → In JSON chuỗi ra console / hiển thị thông báo
```

---

## 4. Hướng dẫn chạy thử nghiệm
```bash
cd Exercises/Slot15/todo_backup_app
flutter run
```
