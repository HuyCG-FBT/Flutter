import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_task_manager/main.dart';
import 'package:smart_task_manager/models/task.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Task Model Tests', () {
    test('toJson and fromJson work correctly', () {
      final task = Task(id: '1', title: 'Test Task', isDone: true);
      final json = task.toJson();
      final restored = Task.fromJson(json);

      expect(restored.id, '1');
      expect(restored.title, 'Test Task');
      expect(restored.isDone, true);
    });
  });

  group('SmartTaskManagerApp Tests', () {
    testWidgets('Displays empty state and allows adding a task',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SmartTaskManagerApp());
      await tester.pumpAndSettle();

      expect(find.text('Smart Task Manager (Offline)'), findsOneWidget);
      expect(find.text('Chưa có task nào.'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Buy Groceries');
      await tester.tap(find.text('Thêm'));
      await tester.pumpAndSettle();

      expect(find.text('Buy Groceries'), findsOneWidget);
      expect(find.text('Chưa có task nào.'), findsNothing);
    });
  });
}
