class Currency {
  final String code;
  final String name;
  final String symbol;
  final double rateToRUB; // Курс к рублю

  Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.rateToRUB,
  });

  // Конвертация суммы
  double convertFromRUB(double amountInRUB) {
    return amountInRUB / rateToRUB;
  }

  // Форматирование суммы
  String format(double amount) {
    return '${amount.toStringAsFixed(2)} $symbol';
  }
}