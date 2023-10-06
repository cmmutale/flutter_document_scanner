import 'package:flutter/material.dart';
import 'cunning_scanner.dart';
import 'genius_scanner.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CunningScanner(),
    );
  }
}
