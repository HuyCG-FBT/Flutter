import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_task_manager_drift/db/app_database.dart';
import 'package:smart_task_manager_drift/repositories/task_dao.dart';

void main() {
  late AppDatabase db;
  late TaskDao dao;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dao = TaskDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift TaskDao CRUD Tests', () {
    test('insertTask and getAllTasks persist and sort by createdAt DESC',
        () async {
      await dao.insertTask(
        id: '1',
        title: 'Task 1',
        createdAt: 1000,
      );
      await dao.insertTask(
        id: '2',
        title: 'Task 2',
        createdAt: 2000,
      );

      final tasks = await dao.getAllTasks();
      expect(tasks.length, 2);
      expect(tasks[0].id, '2');
      expect(tasks[1].id, '1');
    });

    test('toggleDone and updateTitle update the task in SQLite via Drift',
        () async {
      await dao.insertTask(
        id: '1',
        title: 'Old Title',
        createdAt: 1000,
      );

      final initialTasks = await dao.getAllTasks();
      expect(initialTasks.first.isDone, false);

      await dao.toggleDone(initialTasks.first);
      final toggledTasks = await dao.getAllTasks();
      expect(toggledTasks.first.isDone, true);

      await dao.updateTitle(id: '1', newTitle: 'Updated Title');
      final updatedTasks = await dao.getAllTasks();
      expect(updatedTasks.first.title, 'Updated Title');
    });

    test('deleteTask and deleteAll work as expected', () async {
      await dao.insertTask(id: '1', title: 'Task 1', createdAt: 1000);
      await dao.insertTask(id: '2', title: 'Task 2', createdAt: 2000);

      await dao.deleteTask('1');
      var tasks = await dao.getAllTasks();
      expect(tasks.length, 1);
      expect(tasks.first.id, '2');

      await dao.deleteAll();
      tasks = await dao.getAllTasks();
      expect(tasks.isEmpty, true);
    });
  });
}
