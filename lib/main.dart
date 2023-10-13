import 'package:flutter/material.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF11594B)),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF24A09B),
          // secondary: Color(0xFF24A09B),
          // background: Color(0xF4F5F7FF),
          // surface: Color(0xFF1E1E1E),
          // outline: Color(0xFF323333),
        ),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

