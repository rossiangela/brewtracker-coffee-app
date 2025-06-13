import 'package:hive/hive.dart';

import '../../models/recipe.dart';
import '../../models/enums/brew_method.dart';
import '../../models/recipe_step.dart';
import '../../models/extraction_parameters.dart';
class RecipeAdapter extends TypeAdapter<Recipe> {
  @override
  final int typeId = 4;

  @override
  Recipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipe(
      id: fields[0] as String,
      name: fields[1] as String,
      brewMethod: fields[2] as BrewMethod,
      steps: (fields[3] as List).cast<RecipeStep>(),
      parameters: fields[4] as ExtractionParameters,
      notes: fields[5] as String,
      dateCreated: fields[6] as DateTime,
      tags: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Recipe obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.brewMethod)
      ..writeByte(3)
      ..write(obj.steps)
      ..writeByte(4)
      ..write(obj.parameters)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.dateCreated)
      ..writeByte(7)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
