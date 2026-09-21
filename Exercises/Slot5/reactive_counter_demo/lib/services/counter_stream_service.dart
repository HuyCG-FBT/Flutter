import 'dart:async';

class CounterStreamService {
  final _controller = StreamController<int>();
  int _counter = 0;
  Timer? _timer;

  Stream<int> get counterStream => _controller.stream;

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _counter++;
      print('Emit counter: $_counter');
      _controller.add(_counter);
    });
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
