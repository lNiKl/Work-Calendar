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

  double _customEarnings = 0.0; // Пользовательский ввод заработка
  final TextEditingController _earningsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _earningsController.addListener(_updateEarnings);
  }

  @override
  void dispose() {
    _earningsController.dispose();
    super.dispose();
  }

  void _updateEarnings() {
    final value = double.tryParse(_earningsController.text) ?? 0.0;
    setState(() {
      _customEarnings = value;
    });
  }

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
          const SizedBox(height: 16),
          _buildCustomInputCard(), // Добавляем карточку для ввода
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
                  onPressed: () => _selectPeriod(context),
                  tooltip: 'Выбрать период',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${_customEarnings.toStringAsFixed(2)} ₽',
              style: const TextStyle(
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

  Widget _buildCustomInputCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Тестовый ввод данных',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _earningsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Введите сумму заработка (₽)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
                suffixIcon: Icon(Icons.edit),
              ),
              onChanged: (value) {
                // Обновление уже через listener
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final value = double.tryParse(_earningsController.text) ?? 0.0;
                      setState(() {
                        _customEarnings = value * 2; // Простая бизнес-логика: удвоение
                      });
                    },
                    icon: const Icon(Icons.double_arrow),
                    label: const Text('Удвоить'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _earningsController.clear();
                      setState(() {
                        _customEarnings = 0.0;
                      });
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('Сбросить'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  Future<void> _selectPeriod(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      currentDate: DateTime.now(),
      initialDateRange: _selectedPeriod,
    );

    if (picked != null) {
      setState(() {
        _selectedPeriod = picked;
      });
    }
  }
}