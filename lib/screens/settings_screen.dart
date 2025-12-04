import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

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
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context) {
    final currencies = [
      {'code': 'RUB', 'name': 'Российский рубль', 'symbol': '₽'},
      {'code': 'USD', 'name': 'Доллар США', 'symbol': '\$'},
      {'code': 'EUR', 'name': 'Евро', 'symbol': '€'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
          ),
        ],
      ),
    );
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