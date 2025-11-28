import 'package:flutter/material.dart';
import '../services/work_day_repository.dart';
import '../services/currency_service.dart';
import '../models/currency.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/currency_selection_dialog.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late final WorkDayRepository _repository;
  late final CurrencyService _currencyService;
  double _defaultHourlyRate = 500.0;
  double _defaultWorkHours = 8.0;
  String _selectedCurrency = 'RUB';
  Map<String, Currency> _currencies = {};

  @override
  void initState() {
    super.initState();
    _repository = WorkDayRepository();
    _currencyService = CurrencyService();
    _loadSettings();
    _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    _currencies = await _currencyService.getCurrencies();
    setState(() {});
  }

  void _loadSettings() {
    final settings = _repository.getSettings();
    setState(() {
      _defaultHourlyRate = settings['defaultHourlyRate'] ?? 500.0;
      _defaultWorkHours = settings['defaultWorkHours'] ?? 8.0;
      _selectedCurrency = settings['selectedCurrency'] ?? 'RUB';
    });
  }

  void _saveSettings() {
    _repository.saveSettings({
      'defaultHourlyRate': _defaultHourlyRate,
      'defaultWorkHours': _defaultWorkHours,
      'selectedCurrency': _selectedCurrency,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Настройки сохранены'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showDefaultSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Настройки по умолчанию'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ставка в час
            TextFormField(
              initialValue: _defaultHourlyRate.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ставка в час (₽)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              onChanged: (value) {
                final newValue = double.tryParse(value);
                if (newValue != null) {
                  setState(() => _defaultHourlyRate = newValue);
                }
              },
            ),

            const SizedBox(height: 16),

            // Часы работы
            TextFormField(
              initialValue: _defaultWorkHours.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Часы работы в день',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
              onChanged: (value) {
                final newValue = double.tryParse(value);
                if (newValue != null) {
                  setState(() => _defaultWorkHours = newValue);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              _saveSettings();
              Navigator.pop(context);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => CurrencySelectionDialog(
        currencies: _currencies,
        selectedCurrency: _selectedCurrency,
        onCurrencySelected: (currencyCode) {
          setState(() {
            _selectedCurrency = currencyCode;
          });
          _saveSettings();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              // Настройки по умолчанию
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.work_history, color: Colors.blue),
                  title: const Text('Настройки смен по умолчанию'),
                  subtitle: Text('Ставка: ${_defaultHourlyRate.toStringAsFixed(0)}₽/ч, Часы: $_defaultWorkHours'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showDefaultSettingsDialog,
                ),
              ),

              // Валюта отображения
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.currency_exchange, color: Colors.green),
                  title: const Text('Валюта отображения'),
                  subtitle: Text(_currencies[_selectedCurrency]?.name ?? 'Рубли'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showCurrencyDialog,
                ),
              ),

              // Помощь
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.help, color: Colors.orange),
                  title: const Text('Помощь'),
                  subtitle: const Text('Часто задаваемые вопросы'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => showHelpDialog(context),
                ),
              ),

              // О приложении
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.info, color: Colors.purple),
                  title: const Text('О приложении'),
                  subtitle: const Text('Версия 1.0.0'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => showInfoDialog(context),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}