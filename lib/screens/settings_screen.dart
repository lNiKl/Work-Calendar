import 'dart:io';
import 'package:flutter/material.dart';
import '../services/work_day_repository.dart';
import '../services/currency_service.dart';
import '../services/data_export_service.dart';
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
          ),
        ],
      ),
    );
  }

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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
          ),
        ],
      ),
    );

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
