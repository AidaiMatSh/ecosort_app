import 'package:flutter/material.dart';
import '../game/screens/onboarding_game_screen.dart';  // Импорт GameTutorialScreen
import '../profile/screens/profile_screen.dart';    // Импорт ProfileScreen

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  int _previousIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          const Center(child: Text("Map Screen")),
          // Передаём isActiveTab — чтобы GameTutorialScreen знал, активна ли она
          GameTutorialScreen(isActiveTab: _index == 1),
          const Center(child: Text("Chat Screen")),
          const Center(child: Text("Stats Screen")),
          const ProfileScreen(),
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