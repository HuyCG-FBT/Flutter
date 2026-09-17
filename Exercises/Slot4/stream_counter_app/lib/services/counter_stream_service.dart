import 'dart:async';

class CounterStreamService {
  final StreamController<int> _controller = StreamController<int>();
  int _count = 0;

  CounterStreamService() {
    _startCounting();
  }

  Stream<int> get stream => _controller.stream;

  void _startCounting() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _count++;
      print(' Stream phát giá trị: $_count');
      _controller.sink.add(_count);
    });
  }

  void dispose() {
    _controller.close();
  }
}
