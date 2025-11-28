import 'package:flutter/material.dart';
import '../models/WorkDay.dart';
import '../services/work_day_repository.dart';
import '../shared/dialogs/edit_work_day_dialog.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final WorkDayRepository _repository;
  DateTime _currentDate = DateTime.now();
  final Map<DateTime, DayType> _dayTypes = {};

  @override
  void initState() {
    super.initState();
    _repository = WorkDayRepository();
    _loadSavedData();
  }

  void _loadSavedData() {
    final savedDays = _repository.getAllWorkDays();
    for (final workDay in savedDays) {
      // Нормализуем дату (убираем время)
      final normalizedDate = DateTime(workDay.date.year, workDay.date.month, workDay.date.day);
      _dayTypes[normalizedDate] = workDay.type;
    }
  }

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
        onPressed: () => _showAddEventDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Container(
      margin: const EdgeInsets.all(16), // ← Отступы как у календаря
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8), // ← Внутренние отступы
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

    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(Container());
    }

    for (int day = 1; day <= lastDay.day; day++) {
      final date = DateTime(_currentDate.year, _currentDate.month, day);
      final dayType = _dayTypes[date];
      dayWidgets.add(_buildDayCell(day, dayType));
    }

    return Expanded(
        child: Container(
            margin: const EdgeInsets.all(16), // ← Отступы вокруг календаря
            child: Card(                      // ← Карточка вокруг всего календаря
              elevation: 2,                   // Тень
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16), // ← Внутренние отступы
                child: GridView.count(
                  crossAxisCount: 7,
                  children: dayWidgets,
                ),
              ),
            ),
        ),
    );
  }

  Widget _buildDayCell(int day, DayType? dayType) {
    bool isToday = _isToday(day);

    return GestureDetector(
      onTap: () => _onDaySelected(day),
      child: Card(                      // ← Карточка для каждой ячейки
        elevation: 1,                   // Легкая тень
        margin: const EdgeInsets.all(2), // ← Отступы между ячейками
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: _getDayColor(dayType, isToday),
            borderRadius: BorderRadius.circular(8),
            border: isToday
                ? Border.all(color: Colors.blue, width: 2)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day.toString(),
                style: TextStyle(
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
              if (dayType != null) _getDayIcon(dayType),
            ],
          ),
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
    final existingWorkDay = _repository.getWorkDay(date);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Заголовок
              Text(
                '${date.day}.${date.month}.${date.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Быстрый выбор типа
              ...DayType.values.map((type) => Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: _getDayIcon(type),
                  title: Text(
                    _getDayTypeName(type),
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: existingWorkDay?.type == type
                      ? const Icon(Icons.check, color: Colors.green, size: 20)
                      : null,
                  onTap: () => _quickSelectType(date, type),
                ),
              )).toList(),

              // Разделитель
              if (existingWorkDay != null) ...[
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
              ],

              // Расширенное редактирование
              if (existingWorkDay != null) ...[
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.edit, color: Colors.blue),
                    title: const Text(
                      'Редактировать смену',
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showEditDialog(existingWorkDay);
                    },
                  ),
                ),

                Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red, size: 20),
                    title: const Text(
                      'Удалить отметку',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    onTap: () {
                      _deleteWorkDay(date);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],

              // Кнопка отмены
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Отмена',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _quickSelectType(DateTime date, DayType type) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final workDay = WorkDay(
      date: normalizedDate, //data
      type: type,
      hours: _calculateHours(type),
      hourlyRate: _repository.getDefaultHourlyRate(),
      isPaid: type == DayType.work,
    );

    _repository.saveWorkDay(workDay);
    setState(() => _dayTypes[date] = type);
    Navigator.pop(context);
  }

  void _showEditDialog(WorkDay workDay) {
    showDialog(
      context: context,
      builder: (context) => EditWorkDayDialog(
        workDay: workDay,
        onSave: (updatedWorkDay) {
          _repository.saveWorkDay(updatedWorkDay);
          setState(() => _dayTypes[updatedWorkDay.date] = updatedWorkDay.type);
        },
      ),
    );
  }

  double _calculateHours(DayType type) {
    switch (type) {
      case DayType.work:
        return _repository.getDefaultWorkHours();
      case DayType.weekend:
        return 0.0;
      case DayType.vacation:
        return 0.0;
      case DayType.sick:
        return 0.0;
    }
  }
  void _deleteWorkDay(DateTime date) {
    _repository.deleteWorkDay(date);
    setState(() {
      _dayTypes.remove(date);
    });

    // Показываем подтверждение
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Отметка за ${date.day}.${date.month}.${date.year} удалена'),
        duration: Duration(seconds: 2),
      ),
    );
  }
  void _showAddEventDialog(BuildContext context) {
    final today = DateTime.now();
    final existingWorkDay = _repository.getWorkDay(today);
    if (existingWorkDay != null) {
      // Если смена уже есть - редактируем
      _showEditDialog(existingWorkDay);
    } else {
      // Если нет - быстрый выбор типа
      _showDayTypeDialog(today);
    }
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