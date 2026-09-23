import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onSelect;
  final VoidCallback onOpenDetail;

  const StudentCard({
    Key? key,
    required this.student,
    required this.onSelect,
    required this.onOpenDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onOpenDetail, // 👉 MỞ CHI TIẾT
        leading: CircleAvatar(
          child: Text(
            student.name.isNotEmpty ? student.name[0] : '?',
          ),
        ),
        title: Text(student.name),
        subtitle: Text(student.id),
        trailing: IconButton(
          icon: Icon(
            student.isSelected ? Icons.check_circle : Icons.circle_outlined,
            color: student.isSelected ? Colors.green : Colors.grey,
          ),
          onPressed: onSelect, // 👉 CHỈ ĐỔI TRẠNG THÁI
        ),
      ),
    );
  }
}
