import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkCalendar',
      theme: ThemeData.light(),
      home: const MainScreen(),  // ← запускаем MainScreen
    );
  }
}