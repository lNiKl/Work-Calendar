import 'package:flutter/material.dart';

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


class CalendarScreen extends StatefulWidget {
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}
//ЭКРАН КАЛЕНДАРЯ
class _CalendarScreenState extends State<CalendarScreen> {

  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: CalendarDatePicker(
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          onDateChanged: (DateTime value) {
            setState(() {
              _selectedDate = value;
            });
          },
        ),
      ),
    );
  }
}
//ЭКРАН СТАТИСТИКИ
class StatisticScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(  // ← Убрали AppBar и добавили Center
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 64, color: Colors.green),
            SizedBox(height: 20),
            Text('Статистика', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text('Графики и статистика будут здесь'),
          ],
        ),
      ),
    );
  }
}
//ЭКРАН НАСТРОЕК
class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Профиль'),
          subtitle: Text('Настройки профиля'),
          onTap: () => null,//TODO сделать реализацию настроее профиля
        ),
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Уведомления'),
          subtitle: Text('Настройки уведомлений'),
          onTap: () => null,
        ),
        ListTile(
          leading: Icon(Icons.color_lens),
          title: Text('Тема'),
          subtitle: Text('Смена темы приложения'),
          onTap: () => null,
        ),
        ListTile(
          leading: Icon(Icons.help),
          title: Text('Помощь'),
          subtitle: Text('Часто задаваемые вопросы'),
          onTap: () => null,
        ),
      ],
    );
  }
}