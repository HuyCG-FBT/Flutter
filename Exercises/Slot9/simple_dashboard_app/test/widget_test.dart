import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:simple_dashboard_app/main.dart';

void main() {
  testWidgets('Dashboard UI renders correctly and navigates to Product Grid', (WidgetTester tester) async {
    // Build app and trigger a frame
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify Dashboard UI elements
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Hello, User 👋'), findsOneWidget);
    expect(find.text('Welcome back to your dashboard'), findsOneWidget);
    expect(find.byIcon(Icons.notifications), findsOneWidget);
    expect(find.text('Welcome to Simple Product Dashboard'), findsOneWidget);
    expect(find.text('Xem danh sách sản phẩm'), findsOneWidget);

    // Tap 'Xem danh sách sản phẩm' button
    await tester.tap(find.text('Xem danh sách sản phẩm'));
    await tester.pumpAndSettle();

    // Verify navigation to Product Grid Screen
    expect(find.text('Products'), findsOneWidget);
    expect(find.text('Product #0'), findsOneWidget);
    expect(find.text(r'$10.00'), findsOneWidget);
    expect(find.text('Product #1'), findsOneWidget);
    expect(find.text(r'$11.00'), findsOneWidget);

    // Tap back button
    final backButton = find.byTooltip('Back');
    if (backButton.evaluate().isNotEmpty) {
      await tester.tap(backButton);
      await tester.pumpAndSettle();
      expect(find.text('Dashboard'), findsOneWidget);
    }
  });
}
