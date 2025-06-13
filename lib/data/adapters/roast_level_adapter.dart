import 'package:hive/hive.dart';

import '../../models/enums/roast_level.dart';
class RoastLevelAdapter extends TypeAdapter<RoastLevel> {
  @override
  final int typeId = 1;

  @override
  RoastLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RoastLevel.light;
      case 1:
        return RoastLevel.medium;
      case 2:
        return RoastLevel.mediumDark;
      case 3:
        return RoastLevel.dark;
      default:
        return RoastLevel.light;
    }
  }

  @override
  void write(BinaryWriter writer, RoastLevel obj) {
    switch (obj) {
      case RoastLevel.light:
        writer.writeByte(0);
        break;
      case RoastLevel.medium:
        writer.writeByte(1);
        break;
      case RoastLevel.mediumDark:
        writer.writeByte(2);
        break;
      case RoastLevel.dark:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoastLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}



