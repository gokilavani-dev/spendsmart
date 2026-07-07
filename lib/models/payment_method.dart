import 'package:hive/hive.dart';

part 'payment_method.g.dart';

@HiveType(typeId: 2) // 0 = Expense, 1 = Category, so this gets 2
enum PaymentMethod {
  @HiveField(0)
  cash,
  @HiveField(1)
  card,
}
