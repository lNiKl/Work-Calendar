import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}
//ЭКРАН КАЛЕНДАРЯ
class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentDate = DateTime.now();
  Map<DateTime, DayType> _dayTypes = {};

  @override
  void initState() {
  super.initState();
  // Заполняем примерными данными
  _fillExampleData();
  }

  void _fillExampleData() {
  final now = DateTime.now();
  _dayTypes = {
  DateTime(now.year, now.month, 5): DayType.work,
  DateTime(now.year, now.month, 13): DayType.weekend,
  DateTime(now.year, now.month, 20): DayType.vacation,
  DateTime(now.year, now.month, 25): DayType.sick,
  };
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  body: Column(
  children: [
  // Заголовок с месяцем и годом
  _buildMonthHeader(),
  // Дни недели
  _buildWeekDays(),
  // Сетка календаря
  _buildCalendarGrid(),
  ],
  ),
  floatingActionButton: FloatingActionButton(
  onPressed: () => _showAddEventDialog(context),
  child: Icon(Icons.add),
  ),
  );
  }

  Widget _buildMonthHeader() {
  return Padding(
  padding: EdgeInsets.all(16),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  IconButton(
  onPressed: () => _changeMonth(-1),
  icon: Icon(Icons.chevron_left),
  ),
  Text(
  '${_getMonthName(_currentDate.month)} ${_currentDate.year}',
  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  ),
  IconButton(
  onPressed: () => _changeMonth(1),
  icon: Icon(Icons.chevron_right),
  ),
  ],
  ),
  );
  }

  Widget _buildWeekDays() {
  final weekDays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
  return Row(
  children: weekDays.map((day) => Expanded(
  child: Container(
  padding: EdgeInsets.symmetric(vertical: 8),
  decoration: BoxDecoration(
  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
  ),
  child: Text(
  day,
  textAlign: TextAlign.center,
  style: TextStyle(fontWeight: FontWeight.w500),
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

  // Пустые ячейки для начала месяца
  for (int i = 0; i < firstWeekday; i++) {
  dayWidgets.add(Container());
  }

  // Ячейки с числами
  for (int day = 1; day <= lastDay.day; day++) {
  final date = DateTime(_currentDate.year, _currentDate.month, day);
  final dayType = _dayTypes[date];

  dayWidgets.add(_buildDayCell(day, dayType));
  }

  return Expanded(
  child: GridView.count(
  crossAxisCount: 7,
  children: dayWidgets,
  ),
  );
  }

  Widget _buildDayCell(int day, DayType? dayType) {
  bool isToday = _isToday(day);

  return GestureDetector(
  onTap: () => _onDaySelected(day),
  child: Container(
  margin: EdgeInsets.all(2),
  decoration: BoxDecoration(
  color: _getDayColor(dayType, isToday),
  borderRadius: BorderRadius.circular(8),
  border: isToday ? Border.all(color: Colors.blue, width: 2) : null,
  ),
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
  Text(
  day.toString(),
  style: TextStyle(
  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
  ),
  ),
  if (dayType != null) _getDayIcon(dayType),
  ],
  ),
  ),
  );
  }

  Color _getDayColor(DayType? dayType, bool isToday) {
  if (isToday) return Colors.blue.shade50;

  switch (dayType) {
  case DayType.work:
  return Colors.green.shade100;
  case DayType.weekend:
  return Colors.orange.shade100;
  case DayType.vacation:
  return Colors.blue.shade100;
  case DayType.sick:
  return Colors.red.shade100;
  case null:
  return Colors.transparent;
  }
  }

  Widget _getDayIcon(DayType dayType) {
  switch (dayType) {
  case DayType.work:
  return Icon(Icons.work, size: 16, color: Colors.green);
  case DayType.weekend:
  return Icon(Icons.weekend, size: 16, color: Colors.orange);
  case DayType.vacation:
  return Icon(Icons.beach_access, size: 16, color: Colors.blue);
  case DayType.sick:
  return Icon(Icons.medical_services, size: 16, color: Colors.red);
  }
  }

  bool _isToday(int day) {
  final now = DateTime.now();
  return day == now.day &&
  _currentDate.month == now.month &&
  _currentDate.year == now.year;
  }

  void _onDaySelected(int day) {
  final selectedDate = DateTime(_currentDate.year, _currentDate.month, day);
  _showDayTypeDialog(selectedDate);
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

  void _showDayTypeDialog(DateTime date) {
  showDialog(
  context: context,
  builder: (context) => AlertDialog(
  title: Text('${date.day}.${date.month}.${date.year}'),
  content: Column(
  mainAxisSize: MainAxisSize.min,
  children: DayType.values.map((type) => ListTile(
  leading: _getDayIcon(type),
  title: Text(_getDayTypeName(type)),
  onTap: () {
  setState(() {
  _dayTypes[date] = type;
  });
  Navigator.pop(context);
  },
  )).toList(),
  ),
  actions: [
  TextButton(
  onPressed: () => Navigator.pop(context),
  child: Text('Отмена'),
  ),
  ],
  ),
  );
  }

  void _showAddEventDialog(BuildContext context) {
  // TODO: Реализовать диалог добавления события
  }

  String _getDayTypeName(DayType type) {
  switch (type) {
  case DayType.work: return 'Рабочий день';
  case DayType.weekend: return 'Выходной';
  case DayType.vacation: return 'Отпуск';
  case DayType.sick: return 'Больничный';
  }
  }
  }

// Модель типа дня
  enum DayType {
  work,      // Рабочий день
  weekend,   // Выходной
  vacation,  // Отпуск
  sick,      // Больничный
  }