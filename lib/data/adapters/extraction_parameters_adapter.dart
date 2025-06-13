import 'package:hive/hive.dart';

import '../../models/extraction_parameters.dart';
class ExtractionParametersAdapter extends TypeAdapter<ExtractionParameters> {
  @override
  final int typeId = 7;

  @override
  ExtractionParameters read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExtractionParameters(
      coffeeAmount: fields[0] as double,
      waterAmount: fields[1] as double,
      temperature: fields[2] as double,
      totalTimeSeconds: fields[3] as int,
      isCelsius: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ExtractionParameters obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.coffeeAmount)
      ..writeByte(1)
      ..write(obj.waterAmount)
      ..writeByte(2)
      ..write(obj.temperature)
      ..writeByte(3)
      ..write(obj.totalTimeSeconds)
      ..writeByte(4)
      ..write(obj.isCelsius);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExtractionParametersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

