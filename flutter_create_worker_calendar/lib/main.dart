import 'package:flutter/material.dart';
import 'screens/settings_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/statistics_screen.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: MainScreen()
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Список экранов для переключения
  final List<Widget> _screens = [
    CalendarScreen(),    // Экран 0 - Календарь
    StatisticScreen(),   // Экран 1 - Статистика
    SettingScreen(),     // Экран 2 - Настройки
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _getAppBarTitle(),
        actions: _currentIndex == 0 ? [_buildSearchButton()] : null,
      ),

      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),  // ← ИКОНКА КАЛЕНДАРЯ
            label: "Календарь",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),       // ← ИКОНКА СТАТИСТИКИ
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
  // Динамический заголовок AppBar
  Widget _getAppBarTitle() {
    switch (_currentIndex) {
      case 0: return Text('WorkCalendar');
      case 1: return Text('Статистика');
      case 2: return Text('Настройки');
      default: return Text('WorkCalendar');
    }
  }

  // Кнопка поиска только для календаря
  Widget _buildSearchButton() {
    return IconButton(
      onPressed: () => print('Поиск'),
      icon: Icon(Icons.search),
    );
  }
}