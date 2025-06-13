import 'package:hive/hive.dart';

import '../../models/tasting_notes.dart';
class TastingNotesAdapter extends TypeAdapter<TastingNotes> {
  @override
  final int typeId = 2;

  @override
  TastingNotes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TastingNotes(
      sweetness: fields[0] as double,
      acidity: fields[1] as double,
      body: fields[2] as double,
      finish: fields[3] as double,
      notes: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TastingNotes obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.sweetness)
      ..writeByte(1)
      ..write(obj.acidity)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.finish)
      ..writeByte(4)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TastingNotesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}


