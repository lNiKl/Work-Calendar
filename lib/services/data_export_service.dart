import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/WorkDay.dart';
import 'work_day_repository.dart';

class DataExportService {
  final WorkDayRepository _repository;

  DataExportService(this._repository);

  /// Получить директорию для бэкапов
  Future<Directory> _getBackupDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${directory.path}/backups');
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir;
  }

  /// Получить список доступных бэкапов
  Future<List<FileSystemEntity>> getBackupFiles() async {
    final backupDir = await _getBackupDirectory();
    final files = await backupDir.list().toList();
    return files.where((f) => f.path.endsWith('.txt') || f.path.endsWith('.json')).toList()
      ..sort((a, b) => b.path.compareTo(a.path)); // Сортировка по убыванию (новые первые)
  }

  /// Экспорт всех данных в JSON файл
  Future<String?> exportData() async {
    try {
      final workDays = _repository.getAllWorkDays();
      final settings = _repository.getSettings();

      final exportData = {
        'exportDate': DateTime.now().toIso8601String(),
        'version': '1.0',
        'settings': settings,
        'workDays': workDays.map((wd) => _workDayToJson(wd)).toList(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

      final backupDir = await _getBackupDirectory();
      final fileName = 'backup_${_formatDateTime(DateTime.now())}.json';
      final file = File('${backupDir.path}/$fileName');

      await file.writeAsString(jsonString);

      return file.path;
    } catch (e) {
      debugPrint('Ошибка экспорта: $e');
      return null;
    }
  }

  /// Экспорт в текстовый формат
  Future<String?> exportToText() async {
    try {
      final workDays = _repository.getAllWorkDays();
      final settings = _repository.getSettings();

      final buffer = StringBuffer();
      
      buffer.writeln('=== WORK CALENDAR BACKUP ===');
      buffer.writeln('Export Date: ${DateTime.now().toIso8601String()}');
      buffer.writeln('Version: 1.0');
      buffer.writeln('');
      
      buffer.writeln('=== SETTINGS ===');
      buffer.writeln('defaultHourlyRate=${settings['defaultHourlyRate']}');
      buffer.writeln('defaultWorkHours=${settings['defaultWorkHours']}');
      buffer.writeln('selectedCurrency=${settings['selectedCurrency']}');
      buffer.writeln('');
      
      buffer.writeln('=== WORK DAYS ===');
      buffer.writeln('# Format: date|type|hours|hourlyRate|isPaid|notes');
      
      for (final wd in workDays) {
        buffer.writeln('${wd.date.toIso8601String()}|${wd.type.index}|${wd.hours}|${wd.hourlyRate}|${wd.isPaid}|${wd.notes ?? ''}');
      }

      final backupDir = await _getBackupDirectory();
      final fileName = 'backup_${_formatDateTime(DateTime.now())}.txt';
      final file = File('${backupDir.path}/$fileName');
      await file.writeAsString(buffer.toString());

      return file.path;
    } catch (e) {
      debugPrint('Ошибка экспорта в текст: $e');
      return null;
    }
  }

  /// Форматирование даты для имени файла
  String _formatDateTime(DateTime dt) {
    return '${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}_${dt.hour.toString().padLeft(2, '0')}${dt.minute.toString().padLeft(2, '0')}';
  }

  /// Импорт данных из файла по пути
  Future<ImportResult> importFromFile(String filePath) async {
    try {
      final file = File(filePath);
      
      if (!await file.exists()) {
        return ImportResult(success: false, message: 'Файл не найден');
      }

      final content = await file.readAsString();

      if (filePath.endsWith('.json')) {
        return await _importFromJson(content);
      } else if (filePath.endsWith('.txt')) {
        return await _importFromText(content);
      } else {
        return ImportResult(success: false, message: 'Неподдерживаемый формат файла');
      }
    } catch (e) {
      debugPrint('Ошибка импорта: $e');
      return ImportResult(success: false, message: 'Ошибка при импорте: $e');
    }
  }

  /// Удалить файл бэкапа
  Future<bool> deleteBackup(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Ошибка удаления: $e');
      return false;
    }
  }

  /// Импорт из JSON
  Future<ImportResult> _importFromJson(String content) async {
    try {
      final data = jsonDecode(content) as Map<String, dynamic>;

      int importedDays = 0;

      if (data['settings'] != null) {
        final settings = data['settings'] as Map<String, dynamic>;
        await _repository.saveSettings({
          'defaultHourlyRate': (settings['defaultHourlyRate'] as num?)?.toDouble() ?? 500.0,
          'defaultWorkHours': (settings['defaultWorkHours'] as num?)?.toDouble() ?? 8.0,
          'selectedCurrency': settings['selectedCurrency'] ?? 'RUB',
        });
      }

      if (data['workDays'] != null) {
        final workDays = data['workDays'] as List;
        for (final wdJson in workDays) {
          final workDay = _jsonToWorkDay(wdJson as Map<String, dynamic>);
          if (workDay != null) {
            await _repository.saveWorkDay(workDay);
            importedDays++;
          }
        }
      }

      return ImportResult(
        success: true,
        message: 'Импортировано: $importedDays рабочих дней',
        importedCount: importedDays,
      );
    } catch (e) {
      return ImportResult(success: false, message: 'Ошибка парсинга JSON: $e');
    }
  }

  /// Импорт из текстового файла
  Future<ImportResult> _importFromText(String content) async {
    try {
      final lines = content.split('\n');
      int importedDays = 0;
      bool inSettings = false;
      bool inWorkDays = false;

      Map<String, dynamic> settings = {};

      for (final line in lines) {
        final trimmedLine = line.trim();
        
        if (trimmedLine.isEmpty || trimmedLine.startsWith('#')) continue;
        
        if (trimmedLine == '=== SETTINGS ===') {
          inSettings = true;
          inWorkDays = false;
          continue;
        }
        
        if (trimmedLine == '=== WORK DAYS ===') {
          inSettings = false;
          inWorkDays = true;
          continue;
        }

        if (trimmedLine.startsWith('===')) {
          inSettings = false;
          inWorkDays = false;
          continue;
        }

        if (inSettings && trimmedLine.contains('=')) {
          final parts = trimmedLine.split('=');
          if (parts.length == 2) {
            final key = parts[0].trim();
            final value = parts[1].trim();
            
            if (key == 'defaultHourlyRate') {
              settings['defaultHourlyRate'] = double.tryParse(value) ?? 500.0;
            } else if (key == 'defaultWorkHours') {
              settings['defaultWorkHours'] = double.tryParse(value) ?? 8.0;
            } else if (key == 'selectedCurrency') {
              settings['selectedCurrency'] = value;
            }
          }
        }

        if (inWorkDays && trimmedLine.contains('|')) {
          final parts = trimmedLine.split('|');
          if (parts.length >= 5) {
            try {
              final workDay = WorkDay(
                date: DateTime.parse(parts[0]),
                type: DayType.values[int.parse(parts[1])],
                hours: double.parse(parts[2]),
                hourlyRate: double.parse(parts[3]),
                isPaid: parts[4].toLowerCase() == 'true',
                notes: parts.length > 5 && parts[5].isNotEmpty ? parts[5] : null,
              );
              await _repository.saveWorkDay(workDay);
              importedDays++;
            } catch (e) {
              debugPrint('Ошибка парсинга строки: $trimmedLine - $e');
            }
          }
        }
      }

      if (settings.isNotEmpty) {
        await _repository.saveSettings(settings);
      }

      return ImportResult(
        success: true,
        message: 'Импортировано: $importedDays рабочих дней',
        importedCount: importedDays,
      );
    } catch (e) {
      return ImportResult(success: false, message: 'Ошибка парсинга текста: $e');
    }
  }

  Map<String, dynamic> _workDayToJson(WorkDay workDay) {
    return {
      'date': workDay.date.toIso8601String(),
      'type': workDay.type.index,
      'hours': workDay.hours,
      'hourlyRate': workDay.hourlyRate,
      'isPaid': workDay.isPaid,
      'notes': workDay.notes,
    };
  }

  WorkDay? _jsonToWorkDay(Map<String, dynamic> json) {
    try {
      return WorkDay(
        date: DateTime.parse(json['date'] as String),
        type: DayType.values[json['type'] as int],
        hours: (json['hours'] as num).toDouble(),
        hourlyRate: (json['hourlyRate'] as num).toDouble(),
        isPaid: json['isPaid'] as bool? ?? true,
        notes: json['notes'] as String?,
      );
    } catch (e) {
      debugPrint('Ошибка конвертации WorkDay: $e');
      return null;
    }
  }
}

class ImportResult {
  final bool success;
  final String message;
  final int importedCount;

  ImportResult({
    required this.success,
    required this.message,
    this.importedCount = 0,
  });
}
