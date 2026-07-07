import 'package:hive/hive.dart';
import 'payment_method.dart';

part 'income.g.dart';

@HiveType(typeId: 3)
class Income {
  @HiveField(0)
  final String emoji;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final PaymentMethod paymentMethod;

  Income({
    required this.emoji,
    required this.title,
    required this.amount,
    required this.date,
    required this.paymentMethod,
  });
}
