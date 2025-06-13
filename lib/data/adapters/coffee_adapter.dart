import 'package:hive/hive.dart';

import '../../models/coffee.dart';
import '../../models/enums/roast_level.dart';
import '../../models/tasting_notes.dart';
class CoffeeAdapter extends TypeAdapter<Coffee> {
  @override
  final int typeId = 0;

  @override
  Coffee read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Coffee(
      id: fields[0] as String,
      name: fields[1] as String,
      variety: fields[2] as String,
      origin: fields[3] as String,
      roastLevel: fields[4] as RoastLevel,
      roaster: fields[5] as String,
      images: (fields[6] as List).cast<String>(),
      tastingNotes: fields[7] as TastingNotes,
      rating: fields[8] as double,
      dateAdded: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Coffee obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.variety)
      ..writeByte(3)
      ..write(obj.origin)
      ..writeByte(4)
      ..write(obj.roastLevel)
      ..writeByte(5)
      ..write(obj.roaster)
      ..writeByte(6)
      ..write(obj.images)
      ..writeByte(7)
      ..write(obj.tastingNotes)
      ..writeByte(8)
      ..write(obj.rating)
      ..writeByte(9)
      ..write(obj.dateAdded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoffeeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}



