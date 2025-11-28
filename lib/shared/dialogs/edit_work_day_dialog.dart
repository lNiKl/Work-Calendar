import 'package:flutter/material.dart';
import '../../models/WorkDay.dart';

class EditWorkDayDialog extends StatefulWidget {
  final WorkDay workDay;
  final Function(WorkDay) onSave;

  const EditWorkDayDialog({
    super.key,
    required this.workDay,
    required this.onSave,
  });

  @override
  State<EditWorkDayDialog> createState() => _EditWorkDayDialogState();
}

class _EditWorkDayDialogState extends State<EditWorkDayDialog> {
  late double _hours;
  late double _hourlyRate;
  late bool _isPaid;
  late String _notes;
  late DayType _type;

  @override
  void initState() {
    super.initState();
    _hours = widget.workDay.hours;
    _hourlyRate = widget.workDay.hourlyRate;
    _isPaid = widget.workDay.isPaid;
    _notes = widget.workDay.notes ?? '';
    _type = widget.workDay.type;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Редактировать смену'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Тип дня
            DropdownButtonFormField<DayType>(
              value: _type,
              items: DayType.values.map((type) => DropdownMenuItem(
                value: type,
                child: Text(_getDayTypeName(type)),
              )).toList(),
              onChanged: (value) => setState(() => _type = value!),
              decoration: InputDecoration(labelText: 'Тип дня'),
            ),
            SizedBox(height: 16),

            // Часы
            TextFormField(
              initialValue: _hours.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Часы работы'),
              onChanged: (value) => _hours = double.tryParse(value) ?? _hours,
            ),
            SizedBox(height: 16),

            // Ставка
            TextFormField(
              initialValue: _hourlyRate.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Ставка в час (₽)'),
              onChanged: (value) => _hourlyRate = double.tryParse(value) ?? _hourlyRate,
            ),
            SizedBox(height: 16),

            // Оплачиваемый
            if (_type == DayType.sick || _type == DayType.vacation) ...[
              CheckboxListTile(
                title: Text('Оплачиваемый'),
                value: _isPaid,
                onChanged: (value) => setState(() => _isPaid = value ?? false),
              ),
              SizedBox(height: 16),
            ],

            // Заметки
            TextFormField(
              initialValue: _notes,
              decoration: InputDecoration(labelText: 'Заметки'),
              maxLines: 3,
              onChanged: (value) => _notes = value,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text('Сохранить'),
        ),
      ],
    );
  }

  void _save() {
    final updatedWorkDay = widget.workDay.copyWith(
      type: _type,
      hours: _hours,
      hourlyRate: _hourlyRate,
      isPaid: _isPaid,
      notes: _notes.isEmpty ? null : _notes,
    );

    widget.onSave(updatedWorkDay);
    Navigator.pop(context);
  }

  String _getDayTypeName(DayType type) {
    switch (type) {
      case DayType.work: return 'Рабочий день';
      case DayType.weekend: return 'Выходной';
      case DayType.vacation: return 'Отпуск';
      case DayType.sick: return 'Больничный';
    }
  }
}