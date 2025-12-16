// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedItemModelAdapter extends TypeAdapter<SavedItemModel> {
  @override
  final int typeId = 0;

  @override
  SavedItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedItemModel(
      id: fields[0] as String,
      productId: fields[1] as int,
      customName: fields[2] as String,
      productTitle: fields[3] as String,
      productDescription: fields[4] as String,
      productPrice: fields[5] as double,
      productCategory: fields[6] as String,
      productImage: fields[7] as String,
      productRating: fields[8] as double,
      productRatingCount: fields[9] as int,
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SavedItemModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.customName)
      ..writeByte(3)
      ..write(obj.productTitle)
      ..writeByte(4)
      ..write(obj.productDescription)
      ..writeByte(5)
      ..write(obj.productPrice)
      ..writeByte(6)
      ..write(obj.productCategory)
      ..writeByte(7)
      ..write(obj.productImage)
      ..writeByte(8)
      ..write(obj.productRating)
      ..writeByte(9)
      ..write(obj.productRatingCount)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
