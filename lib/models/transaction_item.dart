import 'package:spendsmart/models/expense.dart';
import 'package:spendsmart/models/income.dart';

class TransactionItem {
  final String emoji;
  final String title;
  final double amount;
  final DateTime date;
  final bool isIncome;
  final int originalIndex; // index in its own box (expenses or incomes)

  TransactionItem({
    required this.emoji,
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
    required this.originalIndex,
  });

  factory TransactionItem.fromExpense(Expense e, int index) {
    return TransactionItem(
      emoji: e.emoji,
      title: e.title,
      amount: e.amount,
      date: e.date,
      isIncome: false,
      originalIndex: index,
    );
  }

  factory TransactionItem.fromIncome(Income i, int index) {
    return TransactionItem(
      emoji: i.emoji,
      title: i.title,
      amount: i.amount,
      date: i.date,
      isIncome: true,
      originalIndex: index,
    );
  }
}
