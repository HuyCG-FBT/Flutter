import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_backup_app/main.dart';
import 'package:todo_backup_app/models/todo.dart';
import 'package:todo_backup_app/services/json_service.dart';

void main() {
  group('Todo Model & JsonService Tests', () {
    test('Todo serialization and deserialization', () {
      final todo = Todo(title: 'Study Flutter', done: true);
      final json = todo.toJson();

      expect(json['title'], 'Study Flutter');
      expect(json['done'], true);

      final restored = Todo.fromJson(json);
      expect(restored.title, 'Study Flutter');
      expect(restored.done, true);
    });

    test('JsonService exports list of todos correctly', () {
      final todos = [
        Todo(title: 'Buy milk', done: false),
        Todo(title: 'Study Flutter', done: true),
      ];

      final jsonStr = JsonService.exportTodos(todos);
      expect(jsonStr, contains('"title":"Buy milk"'));
      expect(jsonStr, contains('"done":false'));
      expect(jsonStr, contains('"title":"Study Flutter"'));
      expect(jsonStr, contains('"done":true'));
    });

    test('JsonService imports todos correctly', () {
      const jsonStr = '[{"title":"Test task","done":true}]';
      final list = JsonService.importTodos(jsonStr);

      expect(list.length, 1);
      expect(list.first.title, 'Test task');
      expect(list.first.done, true);
    });
  });

  group('Todo Backup App Widget Tests', () {
    testWidgets('Adds todo and toggles completion', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Kiểm tra tiêu đề
      expect(find.text('Todo Backup App'), findsOneWidget);

      // Nhập task mới
      await tester.enterText(find.byType(TextField), 'Finish Slot 15');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Kiểm tra task đã xuất hiện
      expect(find.text('Finish Slot 15'), findsOneWidget);

      // Tap để toggle hoàn thành (gạch ngang)
      await tester.tap(find.text('Finish Slot 15'));
      await tester.pumpAndSettle();

      // Kiểm tra icon check_circle xuất hiện khi hoàn thành
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      // Nhấn nút export/save
      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      // Kiểm tra SnackBar thông báo xuất JSON
      expect(find.textContaining('Đã backup 1 công việc'), findsOneWidget);
    });
  });
}
