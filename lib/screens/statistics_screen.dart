import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTimeRange _selectedPeriod = DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month, 1),
    end: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildEarningsCard(),
          const SizedBox(height: 16),
          _buildHoursCard(),
          const SizedBox(height: 16),
          _buildShiftsCard(),
        ],
      ),
    );
  }

  Widget _buildEarningsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Заработок',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today, size: 20),
                  onPressed: () {},
                  tooltip: 'Выбрать период',
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '0.00 ₽',
              style: TextStyle(
                fontSize: 24,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Период: ${_formatDate(_selectedPeriod.start)} - ${_formatDate(_selectedPeriod.end)}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoursCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Рабочие часы',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '0ч',
              style: TextStyle(
                fontSize: 24,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Смены',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '0 смен',
              style: TextStyle(
                fontSize: 24,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}