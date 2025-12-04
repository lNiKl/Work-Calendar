import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildMonthHeader(),
          _buildWeekDays(),
          _buildCalendarGrid(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _changeMonth(-1),
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                '${_getMonthName(_currentDate.month)} ${_currentDate.year}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => _changeMonth(1),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekDays() {
    final weekDays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return Row(
      children: weekDays.map((day) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(_currentDate.year, _currentDate.month, 1);
    final lastDay = DateTime(_currentDate.year, _currentDate.month + 1, 0);
    final firstWeekday = firstDay.weekday == 7 ? 0 : firstDay.weekday;

    List<Widget> dayWidgets = [];

    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(Container());
    }

    for (int day = 1; day <= lastDay.day; day++) {
      final bool isToday = _isToday(day);
      dayWidgets.add(_buildDayCell(day, isToday));
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: 7,
              children: dayWidgets,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(int day, bool isToday) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.all(2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isToday ? Colors.blue.shade50 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isToday
                ? Border.all(color: Colors.blue, width: 2)
                : null,
          ),
          child: Center(
            child: Text(
              day.toString(),
              style: TextStyle(
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isToday(int day) {
    final now = DateTime.now();
    return day == now.day &&
        _currentDate.month == now.month &&
        _currentDate.year == now.year;
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + delta, 1);
    });
  }

  String _getMonthName(int month) {
    const months = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];
    return months[month - 1];
  }
}