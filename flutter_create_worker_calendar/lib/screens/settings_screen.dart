import 'package:flutter/material.dart';
import '../widgets/custom_dialog.dart';
//ЭКРАН НАСТРОЕК
class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Профиль'),
          subtitle: Text('Настройки профиля'),
          onTap: () {}, //TODO сделать реализацию настроее профиля
        ),
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Уведомления'),
          subtitle: Text('Настройки уведомлений'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.color_lens),
          title: Text('Тема'),
          subtitle: Text('Смена темы приложения'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.help),
          title: Text('Помощь'),
          subtitle: Text('Часто задаваемые вопросы'),
          onTap: () => showCustomDialog(context),
        ),
      ],
    );
  }
}