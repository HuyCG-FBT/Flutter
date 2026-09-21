import 'package:flutter/material.dart';
import 'services/counter_stream_service.dart';
import 'screens/home_screen.dart';

void main() {
  final service = CounterStreamService();
  service.start();

  runApp(MyApp(service: service));
}

class MyApp extends StatelessWidget {
  final CounterStreamService service;

  const MyApp({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reactive Counter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepOrange,
        useMaterial3: true,
      ),
      home: ReactiveScreen(service: service),
    );
  }
}
