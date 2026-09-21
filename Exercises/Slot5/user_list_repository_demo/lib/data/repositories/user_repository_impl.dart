import 'user_repository.dart';
import '../datasources/user_fake_datasource.dart';
import '../../models/user.dart';

/// Implementation cụ thể của UserRepository.
/// Repository đứng giữa UI & Data Source.
/// Repository KHÔNG chứa UI logic — chỉ điều phối dữ liệu.
class UserRepositoryImpl implements UserRepository {
  final UserFakeDataSource dataSource;

  UserRepositoryImpl(this.dataSource);

  @override
  Future<List<User>> getUsers() {
    return dataSource.getUsers();
  }
}
