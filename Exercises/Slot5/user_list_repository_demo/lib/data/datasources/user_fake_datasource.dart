import '../../models/user.dart';

class UserFakeDataSource {
  Future<List<User>> getUsers() async {
    // Mô phỏng delay như gọi API thật
    await Future.delayed(const Duration(seconds: 1));
    return [
      User(id: 1, name: 'Alice'),
      User(id: 2, name: 'Bob'),
      User(id: 3, name: 'Charlie'),
      User(id: 4, name: 'Diana'),
      User(id: 5, name: 'Eve'),
    ];
  }
}
