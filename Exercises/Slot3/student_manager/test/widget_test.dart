import 'package:flutter_test/flutter_test.dart';
import 'package:student_manager/main.dart';
import 'package:student_manager/models/student.dart';
import 'package:student_manager/services/student_service.dart';

void main() {
  group('Student Model & Service Logic Tests', () {
    test('Student.display returns formatted string', () {
      final s = Student("An", 3.6);
      expect(s.display(), "An - GPA: 3.6");
    });

    test('Student.excellent named constructor works properly', () {
      final s = Student.excellent(name: "Linh");
      expect(s.name, "Linh");
      expect(s.gpa, 4.0);
    });

    test('StudentService filters excellent students (GPA >= 3.6)', () {
      final service = StudentService();
      final excellent = service.getExcellentStudents();
      for (final student in excellent) {
        expect(student.gpa >= 3.6, isTrue);
      }
    });

    test('StudentService filters by custom min GPA', () {
      final service = StudentService();
      final gpa35 = service.filterByMinGpa(3.5);
      for (final student in gpa35) {
        expect(student.gpa >= 3.5, isTrue);
      }
    });
  });

  group('Student Manager UI Tests', () {
    testWidgets('Renders Student Manager title and students list', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Student Manager'), findsOneWidget);
      expect(find.textContaining('An - GPA: 3.6'), findsOneWidget);
      expect(find.textContaining('Binh - GPA: 3.8'), findsOneWidget);
    });
  });
}
