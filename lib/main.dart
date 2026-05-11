import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Импортируем ваши экраны (проверьте правильность путей!)
import 'features/onboarding/onboarding_screen.dart';
import 'features/main/main_screen.dart'; // Путь к вашему файлу main_screen.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  // Раскомментируйте строку ниже ОДИН РАЗ и запустите приложение
  // await prefs.clear();

  final bool accepted = prefs.getBool("accepted") ?? false;
  runApp(EcoSortApp(startAccepted: accepted));
}

class EcoSortApp extends StatelessWidget {
  final bool startAccepted;

  const EcoSortApp({super.key, required this.startAccepted});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoSort App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // Если условия приняты — идем в MainScreen, иначе в Onboarding
      home: startAccepted ? const MainScreen() : const OnboardingScreen(),
    );
  }
}