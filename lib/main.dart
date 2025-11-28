import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/settings_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/main_screen.dart';
import 'models/WorkDay.dart';
import 'services/work_day_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Инициализация Hive
  await Hive.initFlutter();
  Hive.registerAdapter(WorkDayAdapter());
  Hive.registerAdapter(DayTypeAdapter());
  await Hive.openBox<WorkDay>('workDays');
  await Hive.openBox('settings');

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final WorkDayRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = WorkDayRepository();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkCalendar',
      theme: ThemeData.light(),
      home: MainScreen(),
    );
  }
  @override
  void dispose() {
    _repository.close();
    Hive.close(); // Закрыть все боксы
    super.dispose();
  }
}