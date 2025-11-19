import 'package:flutter/material.dart';
import 'package:helloworld/main_screen.dart';
import 'home_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffe7f1f7), // Top section — light grey-blue
              Color(0xFFEEF2F5), // Bottom section — lighter tone
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔸 Title
            const Center(
              child: Text(
                'Welcome to Your Recipe App!',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E2E2E),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 🔸 Image
            Image.asset(
              'assets/kahve_logo.png', // your image here
              height: 250,
            ),
            const SizedBox(height: 30),

            const Text(
              'What will you cook for dinner?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 40),

            // 🔸 Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffffffff),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Explore Recipes 🍲',
                style: TextStyle(fontSize: 18, color: Color(0xff000000)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
