import 'package:flutter/material.dart';
import 'data/datasources/user_fake_datasource.dart';
import 'data/repositories/user_repository_impl.dart';
import 'screens/user_screen.dart';

void main() {
  // Tạo datasource & repository ở đây (ngoài UI)
  // Khi đổi nguồn dữ liệu, CHỈ SỬA Ở ĐÂY — UI không bị ảnh hưởng
  final dataSource = UserFakeDataSource();
  final repository = UserRepositoryImpl(dataSource);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final UserRepositoryImpl repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List Repository Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: UserScreen(repository: repository),
    );
  }
}
