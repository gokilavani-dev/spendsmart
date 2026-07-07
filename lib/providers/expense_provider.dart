import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendsmart/models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;
  final box = Hive.box<Expense>('expenses');

  void loadExpenses() {
    _expenses = box.values.toList();
    notifyListeners();
  }

  void addExpense(Expense expense) {
    box.add(expense);
    _expenses = box.values.toList();
    notifyListeners();
  }

  void deleteExpense(int index) {
    box.deleteAt(index);
    _expenses = box.values.toList();
    notifyListeners();
  }

  void updateExpense(int index, Expense updatedExpense) {
    box.putAt(index, updatedExpense);
    _expenses = box.values.toList();
    notifyListeners();
  }
}
