import 'package:flutter/material.dart';
import '../services/counter_stream_service.dart';

class CounterStreamScreen extends StatefulWidget {
  const CounterStreamScreen({super.key});

  @override
  State<CounterStreamScreen> createState() => _CounterStreamScreenState();
}

class _CounterStreamScreenState extends State<CounterStreamScreen> {
  late CounterStreamService _service;

  @override
  void initState() {
    super.initState();
    _service = CounterStreamService();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream Counter'),
      ),
      body: Center(
        child: StreamBuilder<int>(
          stream: _service.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return Text(
              'Số lượng: ${snapshot.data}',
              style: const TextStyle(fontSize: 32),
            );
          },
        ),
      ),
    );
  }
}
