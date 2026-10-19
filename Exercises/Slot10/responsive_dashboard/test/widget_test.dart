import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:responsive_dashboard/main.dart';

void main() {
  testWidgets('Renders correctly on mobile phone (< 600 width)', (WidgetTester tester) async {
    // Set screen size to mobile phone (400x800)
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const ResponsiveDashboardApp());
    await tester.pumpAndSettle();

    // Verify Dashboard Titles
    expect(find.text('Responsive Dashboard'), findsOneWidget); // AppBar title
    expect(find.text('Dashboard'), findsOneWidget); // _Header title
    expect(find.text('Revenue'), findsOneWidget);
    expect(find.text(r'$12,300'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Customers'), findsOneWidget);

    // Verify grid has 2 columns indicator text
    expect(find.textContaining('2 columns'), findsOneWidget);

    // Verify product cards exist
    expect(find.textContaining('Product number 0'), findsOneWidget);
  });

  testWidgets('Renders correctly on tablet (>= 600 and < 900 width)', (WidgetTester tester) async {
    // Set screen size to tablet (700x1000)
    tester.view.physicalSize = const Size(700, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const ResponsiveDashboardApp());
    await tester.pumpAndSettle();

    // Verify 3 columns indicator text
    expect(find.textContaining('3 columns'), findsOneWidget);
  });

  testWidgets('Renders correctly on desktop (>= 900 width)', (WidgetTester tester) async {
    // Set screen size to desktop (1200x900)
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const ResponsiveDashboardApp());
    await tester.pumpAndSettle();

    // Verify 4 columns indicator text
    expect(find.textContaining('4 columns'), findsOneWidget);
  });
}
