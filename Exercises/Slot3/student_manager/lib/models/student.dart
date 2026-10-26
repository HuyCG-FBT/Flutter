class Student {
  String name;
  double gpa;

  // Constructor chuẩn
  Student(this.name, this.gpa);

  // Bài tập mở rộng 2: Named constructor
  Student.excellent({required this.name, this.gpa = 4.0});

  String display() {
    return "$name - GPA: $gpa";
  }
}
