import 'package:flutter/material.dart';
import 'package:weather_app/pages/onboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "weather_app",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 76, 0, 51),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Onboard(),
    );
  }
}
