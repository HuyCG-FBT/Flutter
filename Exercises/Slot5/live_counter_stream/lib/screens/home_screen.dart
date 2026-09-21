import 'package:flutter/material.dart';
import '../services/counter_stream_service.dart';

class HomeScreen extends StatelessWidget {
  final CounterStreamService _service = CounterStreamService();

  HomeScreen({super.key}) {
    _service.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Counter Stream'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: StreamBuilder<int>(
          stream: _service.counterStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang chờ dữ liệu từ Stream...'),
                ],
              );
            }

            if (snapshot.hasError) {
              return Text(
                'Có lỗi xảy ra: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 18),
              );
            }

            if (!snapshot.hasData) {
              return const Text(
                'Chưa có dữ liệu',
                style: TextStyle(fontSize: 18),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.timer,
                  size: 64,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 16),
                Text(
                  'Counter: ${snapshot.data}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Dữ liệu cập nhật mỗi giây từ Stream',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
