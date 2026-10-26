import '../models/student.dart';

class StudentService {
  List<Student> students = [
    Student("An", 3.6),
    Student("Binh", 3.8),
    Student("Dung", 3.4),
    Student("Cuong", 3.9),
    Student("Hoa", 3.5),
    Student.excellent(name: "Linh"), // Áp dụng named constructor
  ];

  /// Lấy toàn bộ sinh viên
  List<Student> getAllStudents() {
    return students;
  }

  /// Lọc sinh viên xuất sắc (GPA >= 3.6 theo đề bài)
  List<Student> getExcellentStudents() {
    return students.where((s) => s.gpa >= 3.6).toList();
  }

  /// Bài tập mở rộng: Lọc theo GPA tối thiểu (ví dụ: GPA >= 3.5)
  List<Student> filterByMinGpa(double minGpa) {
    return students.where((s) => s.gpa >= minGpa).toList();
  }

  /// Chuẩn bị text hiển thị cho danh sách sinh viên xuất sắc (yêu cầu cơ bản)
  List<String> getDisplayTexts() {
    return getExcellentStudents()
        .map((s) => s.display())
        .toList();
  }

  /// Chuẩn bị text hiển thị theo mức GPA truyền vào
  List<String> getDisplayTextsByFilter({double? minGpa}) {
    final list = minGpa != null ? filterByMinGpa(minGpa) : getAllStudents();
    return list.map((s) => s.display()).toList();
  }

  /// Thêm sinh viên mới (bài tập mở rộng)
  void addStudent(String name, double gpa) {
    students.add(Student(name, gpa));
  }
}
