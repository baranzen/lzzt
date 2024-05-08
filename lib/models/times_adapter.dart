import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class TimestampAdapter extends TypeAdapter<Timestamp> {
  @override
  final int typeId = 2; // Benzersiz bir typeId belirleyin

  @override
  Timestamp read(BinaryReader reader) {
    // `Timestamp` nesnesini okuyarak oluşturun
    final seconds = reader.readInt();
    final nanoseconds = reader.readInt();
    return Timestamp(seconds, nanoseconds);
  }

  @override
  void write(BinaryWriter writer, Timestamp obj) {
    // `Timestamp` nesnesini yazın
    writer.writeInt(obj.seconds);
    writer.writeInt(obj.nanoseconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimestampAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
