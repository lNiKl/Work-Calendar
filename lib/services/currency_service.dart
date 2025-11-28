import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/currency.dart';

class CurrencyService {
    static const String _apiUrl = 'https://www.cbr-xml-daily.ru/daily_json.js';

  // Кэш курсов валют
  static Map<String, Currency> _currencies = {};
  static DateTime _lastUpdate = DateTime(0);

  static void clearCache() {
    _currencies.clear();
  }
  Future<Map<String, Currency>> getCurrencies() async {
    // Если данные устарели (больше 1 часа) - обновляем
    if (DateTime.now().difference(_lastUpdate).inHours > 1) {
      await _fetchCurrencies();
    }

    return _currencies;
  }

  Future<void> _fetchCurrencies() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _parseCurrencies(data);
        _lastUpdate = DateTime.now();
      } else {
        _setDefaultCurrencies();
      }
    } catch (e) {
      _setDefaultCurrencies();
    }
  }

  void _parseCurrencies(Map<String, dynamic> data) {
    _currencies = {
      'RUB': Currency(
        code: 'RUB',
        name: 'Российский рубль',
        symbol: '₽',
        rateToRUB: 1.0,
      ),
      'USD': Currency(
        code: 'USD',
        name: 'Доллар США',
        symbol: '\$',
        rateToRUB: data['Valute']['USD']['Value']?.toDouble() ?? 90.0,
      ),
      'EUR': Currency(
        code: 'EUR',
        name: 'Евро',
        symbol: '€',
        rateToRUB: data['Valute']['EUR']['Value']?.toDouble() ?? 100.0,
      ),
    };
  }

  void _setDefaultCurrencies() {
    _currencies = {
      'RUB': Currency(
        code: 'RUB',
        name: 'Российский рубль',
        symbol: '₽',
        rateToRUB: 1.0,
      ),
      'USD': Currency(
        code: 'USD',
        name: 'Доллар США',
        symbol: '\$',
        rateToRUB: 90.0,
      ),
      'EUR': Currency(
        code: 'EUR',
        name: 'Евро',
        symbol: '€',
        rateToRUB: 100.0,
      ),
    };
  }

  // Получить курс конкретной валюты
  double getRate(String currencyCode) {
    return _currencies[currencyCode]?.rateToRUB ?? 1.0;
  }
}