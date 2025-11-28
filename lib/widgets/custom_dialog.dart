import 'package:flutter/material.dart';

void showHelpDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: AlertDialog(
          title: Row(
            children: [
              Icon(Icons.help, color: Colors.orange),
              SizedBox(width: 8),
              Text('Помощь'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Почта для связи: kolyakostygov@gmail.com'),
              SizedBox(height: 16),
              Text(
                'По всем вопросам и предложениям обращайтесь на указанную почту',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Закрыть'),
            ),
          ],
        ),
      );
    },
  );
}
void showInfoDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: AlertDialog(
          title: Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.purple),
              SizedBox(width: 8),
              Text('WorkCalendar'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Версия приложения 1.0.0'),
              SizedBox(height: 16),
              Text(
                'Приложение разработано студентом 4 курса. '
                    'Оно помогает контролировать отработанные часы, смены,'
                    'а так же считает итоговую ЗП.',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Закрыть'),
            ),
          ],
        ),
      );
    },
  );
}