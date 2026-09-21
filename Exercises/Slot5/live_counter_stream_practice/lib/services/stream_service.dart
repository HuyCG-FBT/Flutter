import 'dart:async';

class StreamService {
  final StreamController<int> _controller = StreamController<int>();

  int _counter = 0;
  Timer? _timer;

  Stream<int> get stream => _controller.stream;

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _counter++;
      print('Stream emits: $_counter');
      _controller.add(_counter);
    });
  }

  /// Mô phỏng lỗi để sinh viên quan sát hasError trong snapshot
  void simulateError() {
    _controller.addError('Lỗi mô phỏng từ Stream!');
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
