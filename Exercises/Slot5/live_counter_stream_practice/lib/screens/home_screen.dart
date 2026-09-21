import 'package:flutter/material.dart';
import '../services/stream_service.dart';

class HomeScreen extends StatelessWidget {
  final StreamService _streamService = StreamService();

  HomeScreen({super.key}) {
    _streamService.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream & UI Reactive Practice'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: StreamBuilder<int>(
          stream: _streamService.stream,
          builder: (context, snapshot) {
            // Log để sinh viên quan sát UI rebuild
            print('UI rebuild: ${snapshot.data}');

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Đang chờ Stream phát dữ liệu...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ],
              );
            }

            if (!snapshot.hasData) {
              return const Text(
                'No data',
                style: TextStyle(fontSize: 18),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.stream,
                  size: 64,
                  color: Colors.teal,
                ),
                const SizedBox(height: 16),
                Text(
                  'Counter: ${snapshot.data}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ConnectionState: ${snapshot.connectionState}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                const Text(
                  'UI tự rebuild – không có setState!',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _streamService.simulateError();
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.error, color: Colors.white),
      ),
    );
  }
}
