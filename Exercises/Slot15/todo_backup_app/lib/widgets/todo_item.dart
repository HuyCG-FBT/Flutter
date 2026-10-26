import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onTap;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        todo.done ? Icons.check_circle : Icons.radio_button_unchecked,
        color: todo.done ? Colors.green : Colors.grey,
      ),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.done ? TextDecoration.lineThrough : null,
          color: todo.done ? Colors.grey : Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }
}
