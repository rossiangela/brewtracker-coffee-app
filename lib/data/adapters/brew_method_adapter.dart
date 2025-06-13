import 'package:hive/hive.dart';

import '../../models/enums/brew_method.dart';
class BrewMethodAdapter extends TypeAdapter<BrewMethod> {
  @override
  final int typeId = 5;

  @override
  BrewMethod read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BrewMethod.espresso;
      case 1:
        return BrewMethod.pourOver;
      case 2:
        return BrewMethod.frenchPress;
      case 3:
        return BrewMethod.aeroPress;
      case 4:
        return BrewMethod.coldBrew;
      default:
        return BrewMethod.pourOver;
    }
  }

  @override
  void write(BinaryWriter writer, BrewMethod obj) {
    switch (obj) {
      case BrewMethod.espresso:
        writer.writeByte(0);
        break;
      case BrewMethod.pourOver:
        writer.writeByte(1);
        break;
      case BrewMethod.frenchPress:
        writer.writeByte(2);
        break;
      case BrewMethod.aeroPress:
        writer.writeByte(3);
        break;
      case BrewMethod.coldBrew:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrewMethodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
