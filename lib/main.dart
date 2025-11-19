import 'package:flutter/material.dart';
import 'package:helloworld/welcome_screen.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.grey),
      color: Colors.blueGrey.shade50,
      home: const WelcomeScreen(),
    );
  }
}
