import 'package:flutter/material.dart';
import 'package:spendsmart/services/settings_service.dart';

class SettingsProvider extends ChangeNotifier {
  double _budget = 0.0;
  String _currency = 'INR';

  final _service = SettingsService();

  double get budget => _budget;
  String get currency => _currency;

  Future<void> loadSettings() async {
    _budget = await _service.getBudget();
    _currency = await _service.getCurrency();
    notifyListeners();
  }

  Future<void> setBudget(double budget) async {
    await _service.saveBudget(budget);
    _budget = budget;
    notifyListeners();
  }

  Future<void> setCurrency(String currency) async {
    await _service.saveCurrency(currency);
    _currency = currency;
    notifyListeners();
  }
}
