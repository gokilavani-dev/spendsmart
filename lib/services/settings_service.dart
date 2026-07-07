import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  Future<void> saveBudget(double budget) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('budget', budget);
  }

  Future<double> getBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('budget') ?? 0.0;
  }

  Future<void> saveCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currency', currency);
  }

  Future<String> getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency') ?? 'INR';
  }
}
