import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main/main_screen.dart';
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> acceptAndContinue(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("accepted", true);

    // После принятия условий переходим на главный экран
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    }
  }

  Future<void> decline(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("accepted", false);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must accept terms to use the app"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "🌱 EcoSort App",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Before using the app, please accept the user agreement.\n\n"
              "This app helps you learn recycling and track eco habits.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => acceptAndContinue(context),
              child: const Text("Accept"),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => decline(context),
              child: const Text("Decline"),
            ),
          ],
        ),
      ),
    );
  }
}