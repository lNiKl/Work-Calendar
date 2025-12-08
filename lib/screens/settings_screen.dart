import 'dart:io';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../services/work_day_repository.dart';
import '../services/currency_service.dart';
import '../services/data_export_service.dart';
import '../models/currency.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/currency_selection_dialog.dart';
=======
>>>>>>> 0a1836f6cf704fdbf6782860f1d24c326bc5dc8a

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

<<<<<<< HEAD
class _SettingScreenState extends State<SettingScreen> {
  late final WorkDayRepository _repository;
  late final CurrencyService _currencyService;
  late final DataExportService _exportService;
  double _defaultHourlyRate = 500.0;
  double _defaultWorkHours = 8.0;
  String _selectedCurrency = 'RUB';
  Map<String, Currency> _currencies = {};
  bool _isExporting = false;
  bool _isImporting = false;

  @override
  void initState() {
    super.initState();
    _repository = WorkDayRepository();
    _currencyService = CurrencyService();
    _exportService = DataExportService(_repository);
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
=======
class _SettingsScreenState extends State<SettingsScreen> {
  double _defaultHourlyRate = 500.0;
  double _defaultWorkHours = 8.0;
  String _selectedCurrency = 'RUB';
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  final List<Map<String, dynamic>> _recentActivities = [
    {'time': '10:30', 'action': 'Добавлена смена'},
    {'time': 'Вчера', 'action': 'Изменена ставка'},
    {'time': '2 дня назад', 'action': 'Добавлено событие'},
  ];
>>>>>>> 0a1836f6cf704fdbf6782860f1d24c326bc5dc8a

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
                  onTap: () => _showDefaultSettingsDialog(context),
                ),
              ),

              // Валюта отображения
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.currency_exchange, color: Colors.green),
                  title: const Text('Валюта отображения'),
                  subtitle: Text(_getCurrencyName(_selectedCurrency)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showCurrencyDialog(context),
                ),
              ),

              // Уведомления
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SwitchListTile(
                  secondary: const Icon(Icons.notifications, color: Colors.orange),
                  title: const Text('Уведомления'),
                  subtitle: const Text('Получать напоминания о сменах'),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                    _showSnackBar(context, 'Уведомления ${value ? 'включены' : 'выключены'}');
                  },
                ),
              ),

              // Темная тема
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SwitchListTile(
                  secondary: const Icon(Icons.dark_mode, color: Colors.purple),
                  title: const Text('Темная тема'),
                  subtitle: const Text('Использовать темное оформление'),
                  value: _darkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      _darkModeEnabled = value;
                    });
                    _showSnackBar(context, 'Темная тема ${value ? 'включена' : 'выключена'}');
                  },
                ),
              ),

              // Последние действия
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Последние действия',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ..._recentActivities.map((activity) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        child: const Icon(Icons.history, size: 18),
                      ),
                      title: Text(activity['action']),
                      subtitle: Text(activity['time']),
                      trailing: IconButton(
                        icon: const Icon(Icons.info_outline, size: 18),
                        onPressed: () {
                          _showActivityDetails(context, activity);
                        },
                      ),
                    )).toList(),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _recentActivities.clear();
                            });
                            _showSnackBar(context, 'История очищена');
                          },
                          child: const Text('Очистить историю'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Разделитель - Работа с данными
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'Работа с данными',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),

              // Экспорт данных
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: _isExporting 
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.upload_file, color: Colors.teal),
                  title: const Text('Экспорт данных'),
                  subtitle: const Text('Сохранить данные в файл'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _isExporting ? null : _showExportDialog,
                ),
              ),

              // Импорт данных
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: _isImporting 
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download, color: Colors.indigo),
                  title: const Text('Импорт данных'),
                  subtitle: const Text('Загрузить данные из файла'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _isImporting ? null : _showImportDialog,
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
                  onTap: () => _showHelpDialog(context),
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
                  onTap: () => _showInfoDialog(context),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  /// Диалог выбора формата экспорта
  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Экспорт данных'),
        content: const Text('Выберите формат файла для экспорта:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _exportData(useJson: false);
            },
            child: const Text('TXT'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _exportData(useJson: true);
            },
            child: const Text('JSON'),
=======
  void _showDefaultSettingsDialog(BuildContext context) {
    final TextEditingController rateController = TextEditingController(
        text: _defaultHourlyRate.toStringAsFixed(0)
    );
    final TextEditingController hoursController = TextEditingController(
        text: _defaultWorkHours.toString()
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Настройки по умолчанию'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ставка в час (₽)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: hoursController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Часы работы в день',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
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
              final newRate = double.tryParse(rateController.text);
              final newHours = double.tryParse(hoursController.text);

              if (newRate != null && newHours != null) {
                setState(() {
                  _defaultHourlyRate = newRate;
                  _defaultWorkHours = newHours;
                });
                _showSnackBar(context, 'Настройки сохранены');
              }
              Navigator.pop(context);
            },
            child: const Text('Сохранить'),
>>>>>>> 0a1836f6cf704fdbf6782860f1d24c326bc5dc8a
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  /// Экспорт данных
  Future<void> _exportData({required bool useJson}) async {
    setState(() => _isExporting = true);
    
    try {
      final path = useJson 
        ? await _exportService.exportData()
        : await _exportService.exportToText();
      
      if (path != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Файл сохранён:\n${path.split('/').last}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ошибка при экспорте данных'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  /// Диалог выбора файла для импорта
  void _showImportDialog() async {
    final files = await _exportService.getBackupFiles();
    
    if (files.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Нет сохранённых бэкапов. Сначала выполните экспорт.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    if (!mounted) return;
=======
  void _showCurrencyDialog(BuildContext context) {
    final currencies = [
      {'code': 'RUB', 'name': 'Российский рубль', 'symbol': '₽'},
      {'code': 'USD', 'name': 'Доллар США', 'symbol': '\$'},
      {'code': 'EUR', 'name': 'Евро', 'symbol': '€'},
    ];
>>>>>>> 0a1836f6cf704fdbf6782860f1d24c326bc5dc8a

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
<<<<<<< HEAD
        title: const Text('Выберите файл'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              final fileName = file.path.split('/').last;
              final isJson = fileName.endsWith('.json');
              
              return Card(
                child: ListTile(
                  leading: Icon(
                    isJson ? Icons.code : Icons.description,
                    color: isJson ? Colors.orange : Colors.blue,
                  ),
                  title: Text(
                    fileName,
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Удалить файл?'),
                          content: Text('Удалить $fileName?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Отмена'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Удалить'),
                            ),
                          ],
                        ),
                      );
                      
                      if (confirmed == true) {
                        await _exportService.deleteBackup(file.path);
                        Navigator.pop(context);
                        _showImportDialog(); // Переоткрыть диалог
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _importData(file.path);
                  },
                ),
=======
        title: const Text('Выберите валюту'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              final currency = currencies[index];
              return RadioListTile<String>(
                title: Text('${currency['name']} (${currency['symbol']})'),
                value: currency['code']!,
                groupValue: _selectedCurrency,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCurrency = value;
                    });
                    _showSnackBar(context, 'Валюта изменена на ${currency['name']}');
                    Navigator.pop(context);
                  }
                },
>>>>>>> 0a1836f6cf704fdbf6782860f1d24c326bc5dc8a
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  /// Импорт данных
  Future<void> _importData(String filePath) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Импорт данных'),
        content: const Text(
          'Импорт заменит текущие настройки и добавит рабочие дни из файла. Продолжить?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Продолжить'),
=======
  void _showActivityDetails(BuildContext context, Map<String, dynamic> activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Детали действия'),
        content: Text(
          'Действие: ${activity['action']}\n'
              'Время: ${activity['time']}\n'
              'Статус: Выполнено',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
>>>>>>> 0a1836f6cf704fdbf6782860f1d24c326bc5dc8a
          ),
        ],
      ),
    );
<<<<<<< HEAD

    if (confirmed != true) return;

    setState(() => _isImporting = true);
    
    try {
      final result = await _exportService.importFromFile(filePath);
      
      if (result.success) {
        _loadSettings();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
      }
    }
  }
}
=======
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.help, color: Colors.orange),
            SizedBox(width: 8),
            Text('Помощь'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Как добавить смену:'),
            Text('1. Нажмите на день в календаре'),
            Text('2. Выберите тип дня'),
            Text('3. Настройте параметры смены'),
            SizedBox(height: 16),
            Text('Как посмотреть статистику:'),
            Text('1. Перейдите на вкладку "Статистика"'),
            Text('2. Выберите период'),
            SizedBox(height: 16),
            Text('По всем вопросам: kolyakostygov@gmail.com'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.purple),
            SizedBox(width: 8),
            Text('WorkCalendar'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Версия приложения: 1.0.0'),
            SizedBox(height: 8),
            Text('Разработчик: Студент 4 курса'),
            SizedBox(height: 8),
            Text(
              'Приложение для учёта рабочих смен, '
                  'расчёта заработка и анализа статистики.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getCurrencyName(String code) {
    switch (code) {
      case 'RUB': return 'Российский рубль (₽)';
      case 'USD': return 'Доллар США (\$)';
      case 'EUR': return 'Евро (€)';
      default: return 'Рубли';
    }
  }
}
>>>>>>> 0a1836f6cf704fdbf6782860f1d24c326bc5dc8a
