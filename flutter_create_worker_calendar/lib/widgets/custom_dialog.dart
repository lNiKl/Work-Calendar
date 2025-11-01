import 'package:flutter/material.dart';

void showCustomDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: AlertDialog(
          content: Text('Почта для связи: @gmail.com'),
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