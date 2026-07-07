// expense.dart

import 'package:hive/hive.dart';
import 'category.dart';
import 'payment_method.dart';
part 'expense.g.dart'; // 👈 auto-generated file (we'll explain this)

@HiveType(typeId: 0) // 👈 "This class = Hive type number 0"
class Expense {
  @HiveField(0) // 👈 emoji gets locker #0
  final String emoji;

  @HiveField(1) // 👈 title gets locker #1
  final String title;

  @HiveField(2) // 👈 amount gets locker #2
  final double amount;

  @HiveField(3) // 👈 date gets locker #3
  final DateTime date;

  @HiveField(4) //
  final Category category;

  @HiveField(5) //
  final PaymentMethod paymentMethod;

  Expense({
    required this.emoji,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.paymentMethod,
  }); // your constructor stays same
}

// _expenses.add(
//               Expense(emoji: '🍕', title: 'Pizza', amount: 300, date: 'Jun 18'),
//             );
// Expense(emoji: '🛒', title: 'Groceries', amount: 850, date: 'Jun 15'),
//     Expense(emoji: '⚡', title: 'Electricity', amount: 1200, date: 'Jun 14'),
//     Expense(emoji: '🍽️', title: 'Dinner', amount: 650, date: 'Jun 13'),
//18001031123-
