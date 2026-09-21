import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_counter_demo/services/counter_stream_service.dart';
import 'package:reactive_counter_demo/screens/home_screen.dart';

void main() {
  testWidgets('ReactiveScreen shows waiting state initially', (tester) async {
    final service = CounterStreamService();
    service.start();

    await tester.pumpWidget(
      MaterialApp(home: ReactiveScreen(service: service)),
    );

    // Kiểm tra trạng thái chờ ban đầu
    expect(find.text('Waiting for Stream...'), findsOneWidget);

    service.dispose();
  });
}
