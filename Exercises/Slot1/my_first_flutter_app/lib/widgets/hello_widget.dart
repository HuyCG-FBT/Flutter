import 'package:flutter/material.dart';

class HelloWidget extends StatelessWidget {
  const HelloWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Hello, Diddy!', style: TextStyle(fontSize: 24)),
    );
  }
}
