// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductsAdapter extends TypeAdapter<Products> {
  @override
  final int typeId = 1;

  @override
  Products read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Products(
      fields[0] as String,
      fields[1] as String,
      fields[2] as double,
      fields[3] as String,
      fields[4] as int,
      fields[5] as String,
      fields[6] as String,
      fields[7] as Timestamp,
    );
  }

  @override
  void write(BinaryWriter writer, Products obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.productName)
      ..writeByte(1)
      ..write(obj.productDescription)
      ..writeByte(2)
      ..write(obj.productPrice)
      ..writeByte(3)
      ..write(obj.productImageURL)
      ..writeByte(4)
      ..write(obj.productStock)
      ..writeByte(5)
      ..write(obj.productOwner)
      ..writeByte(6)
      ..write(obj.productID)
      ..writeByte(7)
      ..write(obj.productDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
