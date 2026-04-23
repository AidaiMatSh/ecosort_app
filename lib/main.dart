// lib/main.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/onboarding/onboarding_screen.dart';
import 'features/game/screens/onboarding_game_screen.dart';
import 'features/stats/stats_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
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
      home: startAccepted ? const MainScreen() : const OnboardingScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  int _previousIndex = 0; // Запоминаем предыдущую вкладку

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          const Center(child: Text("Map Screen")),
          // ✅ Передаём isActiveTab — чтобы GameTutorialScreen знал, активна ли она
          GameTutorialScreen(isActiveTab: _index == 1),
          const Center(child: Text("Chat Screen")),
          StatisticsScreen(),
          const Center(child: Text("Profile Screen")),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) {
          setState(() {
            _previousIndex = _index;
            _index = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: "Game"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}