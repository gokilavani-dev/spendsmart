import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendsmart/models/income.dart';

class IncomeProvider extends ChangeNotifier {
  List<Income> _incomes = [];

  List<Income> get incomes => _incomes;
  final box = Hive.box<Income>('incomes');

  void loadIncomes() {
    _incomes = box.values.toList();
    notifyListeners();
  }

  void addIncome(Income income) {
    box.add(income);
    _incomes = box.values.toList();
    notifyListeners();
  }

  void deleteIncome(int index) {
    box.deleteAt(index);
    _incomes = box.values.toList();
    notifyListeners();
  }

  void updateIncome(int index, Income updatedIncome) {
    box.putAt(index, updatedIncome);
    _incomes = box.values.toList();
    notifyListeners();
  }
}
