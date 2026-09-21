import 'package:flutter/material.dart';
import '../services/counter_stream_service.dart';

/// REACTIVE UI — UI chỉ lắng nghe & hiển thị
/// UI KHÔNG tạo Stream, KHÔNG add dữ liệu, KHÔNG giữ state
class ReactiveScreen extends StatelessWidget {
  final CounterStreamService service;

  const ReactiveScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reactive Counter'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: StreamBuilder<int>(
          stream: service.counterStream,
          builder: (context, snapshot) {
            // Log để chứng minh UI rebuild liên tục
            print('UI rebuild: ${snapshot.data}');

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Waiting for Stream...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
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
                // Icon reactive
                const Icon(
                  Icons.bolt,
                  size: 72,
                  color: Colors.deepOrange,
                ),
                const SizedBox(height: 16),

                // Counter value
                Text(
                  snapshot.data.toString(),
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(height: 8),

                // Connection state info
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'State: ${snapshot.connectionState}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Giải thích tư duy
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text(
                        '⚡ REACTIVE UI',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• UI KHÔNG giữ dữ liệu\n'
                        '• UI KHÔNG xử lý logic\n'
                        '• UI chỉ PHẢN ỨNG khi dữ liệu thay đổi\n'
                        '• Không gọi setState()',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
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
