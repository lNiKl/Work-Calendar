import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CalendarScreen(),
    StatisticsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _getAppBarTitle(),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Календарь",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Статистика",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Настройки",
          ),
        ],
      ),
    );
  }

  Widget _getAppBarTitle() {
    switch (_currentIndex) {
      case 0: return const Text('Календарь');
      case 1: return const Text('Статистика');
      case 2: return const Text('Настройки');
      default: return const Text('WorkCalendar');
    }
  }
}