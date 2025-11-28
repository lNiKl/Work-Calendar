import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'settings_screen.dart';
import 'calendar_screen.dart';
import 'statistics_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const CalendarScreen(),
      const StatisticScreen(),
      const SettingScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: _getAppBarTitle(),
      ),
      body: screens[_currentIndex],
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
      case 0: return Text('WorkCalendar');
      case 1: return Text('Статистика');
      case 2: return Text('Настройки');
      default: return Text('WorkCalendar');
    }
  }
}