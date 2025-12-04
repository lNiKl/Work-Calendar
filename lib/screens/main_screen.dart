import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';
import 'details_screen.dart'; // Добавляем импорт нового экрана

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
      drawer: _buildDrawer(context), // Добавляем Drawer
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Work Calendar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Версия 1.0.0',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Главная'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.details), // ← Вот этот новый пункт
            title: const Text('Детальный просмотр'),
            onTap: () {
              Navigator.pop(context); // Закрываем Drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailsScreen(
                    title: 'Информация',
                    details: 'Этот экран демонстрирует навигацию '
                        'с помощью Navigator.push. '
                        'Здесь могла бы быть детальная информация '
                        'о приложении или пользователе.',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('О приложении'),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Выход'),
            onTap: () {
              Navigator.pop(context);
              // Здесь можно добавить логику выхода
            },
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('О приложении'),
        content: const Text(
          'Work Calendar - приложение для учёта рабочих смен и расчёта заработка.\n\n'
              'Версия: 1.0.0\n'
              'Разработчик: Студент 4 курса',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}