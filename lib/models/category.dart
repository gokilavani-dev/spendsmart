import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(
  typeId: 1,
) // 👈 கவனிங்க: typeId 0 already Expense-க்கு use ஆகிடுச்சு, so இதுக்கு 1
enum Category {
  @HiveField(0)
  groceries,
  @HiveField(1)
  food,
  @HiveField(2)
  travel,
  @HiveField(3)
  entertainment,
  @HiveField(4)
  stay,
  @HiveField(5)
  shopping,
  @HiveField(6)
  bills,
  @HiveField(7)
  health,
  @HiveField(8)
  others,
}

extension CategoryAssets on Category {
  String get assetPath => 'assets/categories/$name.png';
}
