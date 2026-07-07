// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 1;

  @override
  Category read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Category.groceries;
      case 1:
        return Category.food;
      case 2:
        return Category.travel;
      case 3:
        return Category.entertainment;
      case 4:
        return Category.stay;
      case 5:
        return Category.shopping;
      case 6:
        return Category.bills;
      case 7:
        return Category.health;
      case 8:
        return Category.others;
      default:
        return Category.groceries;
    }
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    switch (obj) {
      case Category.groceries:
        writer.writeByte(0);
        break;
      case Category.food:
        writer.writeByte(1);
        break;
      case Category.travel:
        writer.writeByte(2);
        break;
      case Category.entertainment:
        writer.writeByte(3);
        break;
      case Category.stay:
        writer.writeByte(4);
        break;
      case Category.shopping:
        writer.writeByte(5);
        break;
      case Category.bills:
        writer.writeByte(6);
        break;
      case Category.health:
        writer.writeByte(7);
        break;
      case Category.others:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
