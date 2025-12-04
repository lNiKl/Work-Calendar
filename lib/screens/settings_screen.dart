import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                  subtitle: const Text('Ставка: 500₽/ч, Часы: 8'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ),

              // Валюта отображения
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.currency_exchange, color: Colors.green),
                  title: const Text('Валюта отображения'),
                  subtitle: const Text('Рубли'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
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
                  onTap: () {},
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
                  onTap: () {},
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}