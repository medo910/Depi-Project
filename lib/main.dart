import 'package:flutter/material.dart';

void main() {
  runApp(const DepiApp());
}

class DepiApp extends StatelessWidget {
  const DepiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SizedBox(),
    );
  }
}
