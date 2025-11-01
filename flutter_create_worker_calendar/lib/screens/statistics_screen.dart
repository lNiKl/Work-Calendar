import 'package:flutter/material.dart';
//ЭКРАН СТАТИСТИКИ
class StatisticScreen extends StatelessWidget {
  const StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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