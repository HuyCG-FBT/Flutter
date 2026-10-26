// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/json_service.dart';
import '../widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void addTodo() {
    if (controller.text.trim().isEmpty) return;
    setState(() {
      todos.add(Todo(title: controller.text.trim()));
    });
    controller.clear();
  }

  void toggleTodo(int index) {
    setState(() {
      todos[index].done = !todos[index].done;
    });
  }

  void exportJson() {
    final jsonData = JsonService.exportTodos(todos);
    print(jsonData);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Đã backup ${todos.length} công việc ra Console!"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Backup App"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: "Export JSON",
            onPressed: exportJson,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Enter task",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: (_) => addTodo(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: addTodo,
                )
              ],
            ),
          ),
          Expanded(
            child: todos.isEmpty
                ? const Center(
                    child: Text(
                      "Chưa có công việc nào.\nHãy nhập công việc và bấm + để thêm!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return TodoItem(
                        todo: todo,
                        onTap: () => toggleTodo(index),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
