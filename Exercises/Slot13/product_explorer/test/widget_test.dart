import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_explorer/widgets/error_widget.dart';
import 'package:product_explorer/widgets/loading_widget.dart';

void main() {
  testWidgets('LoadingWidget displays message and spinner', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LoadingWidget(message: 'Fetching products...'),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Fetching products...'), findsOneWidget);
  });

  testWidgets('AppErrorWidget displays error message and invokes onRetry', (WidgetTester tester) async {
    bool retried = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppErrorWidget(
            message: 'Failed to connect to server',
            onRetry: () {
              retried = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Failed to connect to server'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    expect(retried, isTrue);
  });
}
