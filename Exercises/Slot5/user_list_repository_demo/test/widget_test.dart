import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_list_repository_demo/data/datasources/user_fake_datasource.dart';
import 'package:user_list_repository_demo/data/repositories/user_repository_impl.dart';
import 'package:user_list_repository_demo/screens/user_screen.dart';

void main() {
  testWidgets('UserScreen shows loading indicator initially', (tester) async {
    final dataSource = UserFakeDataSource();
    final repository = UserRepositoryImpl(dataSource);

    await tester.pumpWidget(
      MaterialApp(home: UserScreen(repository: repository)),
    );

    // Kiểm tra trạng thái loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
