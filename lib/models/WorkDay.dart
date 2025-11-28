import 'package:hive/hive.dart';

part 'WorkDay.g.dart'; // Файл который сгенерируется

@HiveType(typeId: 0)
class WorkDay {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final DayType type;

  @HiveField(2)
  double hours;

  @HiveField(3)
  double hourlyRate;

  @HiveField(4)
  final String? notes;

  @HiveField(5)
  bool isPaid;

  WorkDay({
    required this.date,
    required this.type,
    this.hours = 8.0,
    this.hourlyRate = 0.0,
    this.notes,
    this.isPaid = true,
  });

  double get earnings => isPaid ? hours * hourlyRate : 0.0;
  double getEarningsInCurrency(double rateToRUB) {
    return earnings / rateToRUB;
  }

  // Форматированный заработок в валюте
  String formatEarnings(String symbol, double rateToRUB) {
    final amount = getEarningsInCurrency(rateToRUB);
    return '${amount.toStringAsFixed(2)} $symbol';
  }
  // Метод для копирования с изменениями
  WorkDay copyWith({
    DateTime? date,
    DayType? type,
    double? hours,
    double? hourlyRate,
    String? notes,
    bool? isPaid,
  }) {
    return WorkDay(
      date: date ?? this.date,
      type: type ?? this.type,
      hours: hours ?? this.hours,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      notes: notes ?? this.notes,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}

@HiveType(typeId: 1)
enum DayType {
  @HiveField(0)
  work,
  @HiveField(1)
  weekend,
  @HiveField(2)
  vacation,
  @HiveField(3)
  sick,
}