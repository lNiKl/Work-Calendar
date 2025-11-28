import 'package:flutter/material.dart';
import '../widgets/currency_selection_dialog.dart';
import '../services/work_day_repository.dart';
import '../services/currency_service.dart';
import '../models/currency.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  late final WorkDayRepository _repository;
  late final CurrencyService _currencyService;
  late DateTimeRange _selectedPeriod;

  double _totalEarnings = 0.0;
  int _totalHours = 0;
  int _totalShifts = 0;
  String _selectedCurrency = 'RUB';
  Map<String, Currency> _currencies = {};
  double _currentRate = 1.0;

  @override
  void initState() {
    super.initState();
    _repository = WorkDayRepository();
    _currencyService = CurrencyService();
    _selectedPeriod = _repository.getStatsPeriod();
    _loadCurrencyData();
  }

  Future<void> _loadCurrencyData() async {
    _selectedCurrency = _repository.getSelectedCurrency();
    _currencies = await _currencyService.getCurrencies();
    _currentRate = _currencies[_selectedCurrency]?.rateToRUB ?? 1.0;
    _calculateStatistics();
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
      _repository.saveStatsPeriod(picked);
      _calculateStatistics();
    }
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
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.currency_exchange, size: 20),
                      onPressed: _showCurrencyDialog,
                      tooltip: 'Выбрать валюту',
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today, size: 20),
                      onPressed: () => _selectPeriod(context),
                      tooltip: 'Выбрать период',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _formatEarnings(_totalEarnings),
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
            const SizedBox(height: 4),
            Text(
              'Курс: 1 ${_currencies[_selectedCurrency]?.symbol ?? '₽'} = ${_currentRate.toStringAsFixed(2)} ₽',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
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
            Text(
              '${_totalHours}ч',
              style: const TextStyle(
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
            Text(
              '$_totalShifts смен',
              style: const TextStyle(
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

  String _formatEarnings(double amountInRUB) {
    final currency = _currencies[_selectedCurrency];
    if (currency != null) {
      return currency.format(amountInRUB / _currentRate);
    }
    return '${amountInRUB.toStringAsFixed(2)} ₽';
  }

  void _calculateStatistics() {
    final workDays = _repository.getAllWorkDays();
    final filteredDays = workDays.where((day) =>
    day.date.isAfter(_selectedPeriod.start.subtract(const Duration(days: 1))) &&
        day.date.isBefore(_selectedPeriod.end.add(const Duration(days: 1)))
    ).toList();

    setState(() {
      _totalEarnings = filteredDays.fold(0.0, (sum, day) => sum + day.earnings);
      _totalHours = filteredDays.fold(0, (sum, day) => sum + day.hours.toInt());
      _totalShifts = filteredDays.length;
    });
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => CurrencySelectionDialog(
        currencies: _currencies,
        selectedCurrency: _selectedCurrency,
        onCurrencySelected: (currencyCode) {
          _repository.saveSelectedCurrency(currencyCode);
          setState(() {
            _selectedCurrency = currencyCode;
            _currentRate = _currencies[currencyCode]?.rateToRUB ?? 1.0;
          });
        },
      ),
    );
  }
}