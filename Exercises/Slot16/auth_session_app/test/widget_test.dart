import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth_session_app/main.dart';
import 'package:auth_session_app/services/auth_service.dart';
import 'package:auth_session_app/services/session_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Auth & Session Service Logic Tests', () {
    test('AuthService login succeeds with valid credentials', () async {
      final result = await AuthService.login("admin", "1234");
      expect(result, isTrue);

      final isLogged = await SessionService.isLoggedIn();
      expect(isLogged, isTrue);
    });

    test('AuthService login fails with invalid credentials', () async {
      await SessionService.clearSession();
      final result = await AuthService.login("user", "wrongpass");
      expect(result, isFalse);

      final isLogged = await SessionService.isLoggedIn();
      expect(isLogged, isFalse);
    });

    test('SessionService saves and clears session properly', () async {
      await SessionService.saveSession(true);
      expect(await SessionService.isLoggedIn(), isTrue);

      await SessionService.clearSession();
      expect(await SessionService.isLoggedIn(), isFalse);
    });
  });

  group('Auth Session App UI Tests', () {
    testWidgets('Validates form inputs on LoginScreen', (tester) async {
      await tester.pumpWidget(const MyApp(initialLoggedIn: false));
      await tester.pumpAndSettle();

      // Kiểm tra đang ở màn hình Login
      expect(find.text('Login'), findsWidgets);

      // Bấm nút Login khi chưa nhập gì
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      // Kiểm tra thông báo lỗi validation
      expect(find.text('Enter username'), findsOneWidget);
      expect(find.text('Password too short'), findsOneWidget);
    });

    testWidgets('Full login flow to Dashboard', (tester) async {
      await tester.pumpWidget(const MyApp(initialLoggedIn: false));
      await tester.pumpAndSettle();

      // Nhập credentials hợp lệ
      await tester.enterText(find.byType(TextFormField).at(0), 'admin');
      await tester.enterText(find.byType(TextFormField).at(1), '1234');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      // Kiểm tra đã vào Dashboard
      expect(find.text('Welcome to Dashboard'), findsOneWidget);
      expect(find.text('Open Profile'), findsOneWidget);
    });
  });
}
