import 'package:flutter/material.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const SmartProfileEditorApp());
}

class SmartProfileEditorApp extends StatelessWidget {
  const SmartProfileEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Profile Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const ProfileScreen(),
    );
  }
}
