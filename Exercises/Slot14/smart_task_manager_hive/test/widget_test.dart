import 'package:flutter_test/flutter_test.dart';
import 'package:smart_task_manager_hive/models/task.dart';

void main() {
  group('Task Hive Model Tests', () {
    test('toMap and fromMap serialize and deserialize accurately', () {
      final task = Task(
        id: 'hive_1',
        title: 'Learn Hive NoSQL',
        isDone: true,
        createdAt: 1710000000000,
      );

      final map = task.toMap();
      expect(map['id'], 'hive_1');
      expect(map['title'], 'Learn Hive NoSQL');
      expect(map['isDone'], true);
      expect(map['createdAt'], 1710000000000);

      final reconstructed = Task.fromMap(map);
      expect(reconstructed.id, 'hive_1');
      expect(reconstructed.title, 'Learn Hive NoSQL');
      expect(reconstructed.isDone, true);
      expect(reconstructed.createdAt, 1710000000000);
    });

    test('fromMap provides defaults when fields are missing or null', () {
      final map = {
        'id': 'hive_2',
        'title': 'Default task',
      };

      final task = Task.fromMap(map);
      expect(task.id, 'hive_2');
      expect(task.title, 'Default task');
      expect(task.isDone, false);
      expect(task.createdAt, 0);
    });
  });
}
