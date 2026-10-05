import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/student_tile.dart';
import '../routes/app_routes.dart';
import 'student_form_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({Key? key}) : super(key: key);

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  // Danh sách sinh viên giả lập (trong bộ nhớ)
  final List<Student> _students = [
    Student(id: 'S001', name: 'Nguyễn Văn A', age: 20),
    Student(id: 'S002', name: 'Trần Thị B', age: 21),
    Student(id: 'S003', name: 'Lê Văn C', age: 19),
  ];

  void _goToDetail(Student student) {
    // Navigator 1.0 + Named Route + arguments
    Navigator.pushNamed(
      context,
      AppRoutes.studentDetail,
      arguments: student,
    );
  }

  Future<void> _goToForm() async {
    // Mở form để tạo mới
    // Ở đây dùng push (không named) để sinh viên thấy sự khác nhau
    final result = await Navigator.push<Student?>(
      context,
      MaterialPageRoute(
        builder: (ctx) => const StudentFormScreen(),
      ),
    );

    // Khi form pop về, nếu có student mới thì thêm vào list
    if (result != null) {
      setState(() {
        _students.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách sinh viên'),
      ),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final student = _students[index];
          return StudentTile(
            student: student,
            onTap: () => _goToDetail(student),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
