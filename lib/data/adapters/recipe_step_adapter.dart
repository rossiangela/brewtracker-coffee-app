import 'package:hive/hive.dart';

import '../../models/recipe_step.dart';
class RecipeStepAdapter extends TypeAdapter<RecipeStep> {
  @override
  final int typeId = 6;

  @override
  RecipeStep read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeStep(
      instruction: fields[0] as String,
      durationSeconds: fields[1] as int,
      order: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeStep obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.instruction)
      ..writeByte(1)
      ..write(obj.durationSeconds)
      ..writeByte(2)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeStepAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}