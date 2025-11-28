import 'package:flutter/material.dart'; // ← Добавь этот импорт
import 'package:hive_flutter/hive_flutter.dart';
import '../models/WorkDay.dart';

class WorkDayRepository {
  late final Box<WorkDay> _workDayBox;
  late final Box _settingsBox;

  Future<void> close() async {
    await _workDayBox.close();
    await _settingsBox.close();
  }

  WorkDayRepository() {
    _workDayBox = Hive.box<WorkDay>('workDays');
    _settingsBox = Hive.box('settings');
  }

  Future<void> saveWorkDay(WorkDay workDay) async {
    await _workDayBox.put(workDay.date.toIso8601String(), workDay);
  }

  WorkDay? getWorkDay(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return _workDayBox.get(normalizedDate.toIso8601String());
  }

  List<WorkDay> getAllWorkDays() {
    return _workDayBox.values.toList();
  }

  Future<void> deleteWorkDay(DateTime date) async {
    await _workDayBox.delete(date.toIso8601String());
  }

  // Сохранить период статистики
  Future<void> saveStatsPeriod(DateTimeRange period) async {
    await _settingsBox.put('stats_period_start', period.start.toIso8601String());
    await _settingsBox.put('stats_period_end', period.end.toIso8601String());
  }

  // Загрузить период статистики
  DateTimeRange getStatsPeriod() {
    final startStr = _settingsBox.get('stats_period_start');
    final endStr = _settingsBox.get('stats_period_end');

    if (startStr != null && endStr != null) {
      return DateTimeRange(
        start: DateTime.parse(startStr),
        end: DateTime.parse(endStr),
      );
    }

    // По умолчанию - текущий месяц
    return DateTimeRange(
      start: DateTime(DateTime.now().year, DateTime.now().month, 1),
      end: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
    );
  }
  // Сохранить настройки
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _settingsBox.put('defaultHourlyRate', settings['defaultHourlyRate']);
    await _settingsBox.put('defaultWorkHours', settings['defaultWorkHours']);
    if (settings['selectedCurrency'] != null) {
      await saveSelectedCurrency(settings['selectedCurrency']);
    }
  }

  Map<String, dynamic> getSettings() {
    return {
      'defaultHourlyRate': _settingsBox.get('defaultHourlyRate') ?? 500.0,
      'defaultWorkHours': _settingsBox.get('defaultWorkHours') ?? 8.0,
      'selectedCurrency': getSelectedCurrency(),
    };
  }

// Получить ставку по умолчанию
  double getDefaultHourlyRate() {
    return _settingsBox.get('defaultHourlyRate') ?? 500.0;
  }

// Получить часы по умолчанию
  double getDefaultWorkHours() {
    return _settingsBox.get('defaultWorkHours') ?? 8.0;
  }
  // Сохранить выбранную валюту
  Future<void> saveSelectedCurrency(String currencyCode) async {
    await _settingsBox.put('selectedCurrency', currencyCode);
  }

  // Получить выбранную валюту
  String getSelectedCurrency() {
    return _settingsBox.get('selectedCurrency') ?? 'RUB';
  }
}
