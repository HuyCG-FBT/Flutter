import 'dart:convert';
import '../models/todo.dart';

class JsonService {
  /// Chuyển đổi danh sách Todo thành chuỗi JSON backup
  static String exportTodos(List<Todo> todos) {
    final list = todos.map((e) => e.toJson()).toList();
    return jsonEncode(list);
  }

  /// Khôi phục danh sách Todo từ chuỗi JSON
  static List<Todo> importTodos(String jsonStr) {
    if (jsonStr.trim().isEmpty) return [];
    try {
      final dynamic decoded = jsonDecode(jsonStr);
      if (decoded is List) {
        return decoded
            .map((e) => Todo.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      return [];
    }
    return [];
  }
}
