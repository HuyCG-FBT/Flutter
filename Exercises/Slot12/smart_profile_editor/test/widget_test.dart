import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_profile_editor/models/profile_model.dart';
import 'package:smart_profile_editor/repositories/profile_repository.dart';
import 'package:smart_profile_editor/screens/profile_screen.dart';
import 'package:smart_profile_editor/services/draft_service.dart';

class FakeProfileRepository extends ProfileRepository {
  Profile profile;
  bool shouldThrow;

  FakeProfileRepository({
    this.profile = const Profile(
      name: 'Leanne Graham',
      email: 'Sincere@april.biz',
      phone: '1-770-736-8031',
    ),
    this.shouldThrow = false,
  });

  @override
  Future<Profile> getProfile() async {
    if (shouldThrow) throw Exception("Network failure");
    return profile;
  }

  @override
  Future<void> updateProfile(Profile newProfile) async {
    if (shouldThrow) throw Exception("Update failure");
    profile = newProfile;
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Loads profile and displays data in form fields', (WidgetTester tester) async {
    final fakeRepo = FakeProfileRepository();
    final draftService = DraftService();

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          repository: fakeRepo,
          draftService: draftService,
        ),
      ),
    );

    // Initial pump for bootstrap
    await tester.pumpAndSettle();

    // Verify fields populated
    expect(find.text('Leanne Graham'), findsOneWidget);
    expect(find.text('Sincere@april.biz'), findsOneWidget);
    expect(find.text('1-770-736-8031'), findsOneWidget);
    expect(find.text('Lưu cập nhật'), findsOneWidget);
  });

  testWidgets('Shows validation error on invalid email and phone', (WidgetTester tester) async {
    final fakeRepo = FakeProfileRepository();
    final draftService = DraftService();

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          repository: fakeRepo,
          draftService: draftService,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Clear email field and enter invalid email
    final emailField = find.widgetWithText(TextFormField, 'Email');
    await tester.enterText(emailField, 'invalid-email');
    await tester.pumpAndSettle();

    expect(find.text('Email không hợp lệ (ví dụ: a@b.com)'), findsOneWidget);
  });

  testWidgets('Submits updated profile and shows success SnackBar', (WidgetTester tester) async {
    final fakeRepo = FakeProfileRepository();
    final draftService = DraftService();

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          repository: fakeRepo,
          draftService: draftService,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Update name
    final nameField = find.widgetWithText(TextFormField, 'Họ tên');
    await tester.enterText(nameField, 'Jane Doe');
    await tester.pumpAndSettle();

    // Tap submit button
    await tester.tap(find.text('Lưu cập nhật'));
    await tester.pump(); // Enter loading

    await tester.pumpAndSettle(); // Complete update

    // Check SnackBar
    expect(find.text('Cập nhật thành công'), findsOneWidget);
    expect(fakeRepo.profile.name, 'Jane Doe');
  });

  testWidgets('Shows error view when loading fails and can retry', (WidgetTester tester) async {
    final fakeRepo = FakeProfileRepository(shouldThrow: true);
    final draftService = DraftService();

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          repository: fakeRepo,
          draftService: draftService,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Không tải được dữ liệu'), findsOneWidget);
    expect(find.text('Thử lại'), findsOneWidget);

    // Turn off error and tap retry
    fakeRepo.shouldThrow = false;
    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();

    expect(find.text('Leanne Graham'), findsOneWidget);
  });
}
