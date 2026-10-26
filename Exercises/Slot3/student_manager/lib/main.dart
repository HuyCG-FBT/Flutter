import 'package:flutter/material.dart';
import 'services/student_service.dart';
import 'widgets/student_tile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const StudentManagerPage(),
    );
  }
}

class StudentManagerPage extends StatefulWidget {
  const StudentManagerPage({super.key});

  @override
  State<StudentManagerPage> createState() => _StudentManagerPageState();
}

class _StudentManagerPageState extends State<StudentManagerPage> {
  // Khởi tạo service xử lý logic
  final StudentService _service = StudentService();

  // Mức lọc hiện tại: null = tất cả, 3.5 = khá giỏi, 3.6 = xuất sắc
  double? _selectedGpaFilter = 3.6;

  @override
  Widget build(BuildContext context) {
    // UI CHỈ NHẬN KẾT QUẢ ĐÃ XỬ LÝ TỪ SERVICE
    final List<String> data = _service.getDisplayTextsByFilter(
      minGpa: _selectedGpaFilter,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Manager"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Khu vực lựa chọn bộ lọc (Filter) - Bài tập mở rộng 1 & 3
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            color: Colors.blue.withValues(alpha: 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Bộ lọc:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text("Tất cả"),
                  selected: _selectedGpaFilter == null,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedGpaFilter = null);
                    }
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text("GPA ≥ 3.5"),
                  selected: _selectedGpaFilter == 3.5,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedGpaFilter = 3.5);
                    }
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text("GPA ≥ 3.6 (Xuất sắc)"),
                  selected: _selectedGpaFilter == 3.6,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedGpaFilter = 3.6);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Hiển thị số lượng
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Danh sách (${data.length} sinh viên):",
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Danh sách sinh viên - Sử dụng .map() biến dữ liệu thành widget
          Expanded(
            child: ListView(
              children: data.map((text) {
                // Sử dụng widget đã tách riêng (Bài tập mở rộng 4)
                return StudentTile(displayText: text);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
