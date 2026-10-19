import 'package:flutter_test/flutter_test.dart';
import 'package:smart_task_manager_sqlite/models/task.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Task SQLite Model Tests', () {
    test('toMap and fromMap work correctly with bool conversion to int', () {
      final task = Task(
        id: 'task_1',
        title: 'Learn SQLite',
        isDone: true,
        createdAt: 1700000000000,
      );

      final map = task.toMap();
      expect(map['id'], 'task_1');
      expect(map['title'], 'Learn SQLite');
      expect(map['is_done'], 1);
      expect(map['created_at'], 1700000000000);

      final fromMapTask = Task.fromMap(map);
      expect(fromMapTask.id, 'task_1');
      expect(fromMapTask.title, 'Learn SQLite');
      expect(fromMapTask.isDone, true);
      expect(fromMapTask.createdAt, 1700000000000);
    });

    test('fromMap handles false is_done (0)', () {
      final map = {
        'id': 'task_2',
        'title': 'Undone Task',
        'is_done': 0,
        'created_at': 1700000000100,
      };

      final task = Task.fromMap(map);
      expect(task.isDone, false);
    });
  });
}
