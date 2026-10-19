import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_registration_app/main.dart';

void main() {
  testWidgets('Smart Registration App initial UI and validation tests', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartRegistrationApp());
    await tester.pumpAndSettle();

    // Verify fields and buttons exist
    expect(find.text('Register'), findsNWidgets(2)); // AppBar title & Button
    expect(find.byType(TextFormField), findsNWidgets(4));

    // Submit without input -> should trigger validation errors
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pumpAndSettle();

    expect(find.text('Field is required'), findsNWidgets(2)); // Name & Confirm
    expect(find.text('Email required'), findsOneWidget); // Email
    expect(find.text('Password must be at least 6 characters'), findsOneWidget); // Password
  });

  testWidgets('Shows SnackBar when passwords do not match', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartRegistrationApp());
    await tester.pumpAndSettle();

    // Fill valid name, email, but mismatching passwords
    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
    await tester.enterText(find.byType(TextFormField).at(1), 'john@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.enterText(find.byType(TextFormField).at(3), 'differentPassword');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('Shows error SnackBar when email is test@error.com', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartRegistrationApp());
    await tester.pumpAndSettle();

    // Fill with error email
    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
    await tester.enterText(find.byType(TextFormField).at(1), 'test@error.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.enterText(find.byType(TextFormField).at(3), 'password123');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pump(); // Enter loading state

    // Verify loading indicator is present and button is gone
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Fast-forward 2 seconds to complete API call
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Verify error SnackBar
    expect(find.textContaining('Email already exists'), findsOneWidget);
  });

  testWidgets('Navigates to SuccessScreen upon successful registration', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartRegistrationApp());
    await tester.pumpAndSettle();

    // Fill valid data
    await tester.enterText(find.byType(TextFormField).at(0), 'Alice');
    await tester.enterText(find.byType(TextFormField).at(1), 'alice@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'securePass123');
    await tester.enterText(find.byType(TextFormField).at(3), 'securePass123');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pump();

    // In loading state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait 2 seconds for fake API call
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Verify on SuccessScreen
    expect(find.text('Registration Successful!'), findsOneWidget);
  });
}
