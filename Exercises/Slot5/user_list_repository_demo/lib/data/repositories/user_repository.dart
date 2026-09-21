import '../../models/user.dart';

/// Repository Interface (Abstract Class)
/// UI chỉ biết interface này, không biết implementation bên dưới.
/// Đây là "hợp đồng" giữa UI và Data Layer.
abstract class UserRepository {
  Future<List<User>> getUsers();
}
