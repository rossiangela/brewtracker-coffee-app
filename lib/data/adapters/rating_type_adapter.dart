import 'package:hive/hive.dart';

import '../../models/enums/rating_type.dart';

class RatingTypeAdapter extends TypeAdapter<RatingType> {
  @override
  final int typeId = 3;

  @override
  RatingType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RatingType.stars;
      case 1:
        return RatingType.score;
      case 2:
        return RatingType.emoji;
      default:
        return RatingType.stars;
    }
  }

  @override
  void write(BinaryWriter writer, RatingType obj) {
    switch (obj) {
      case RatingType.stars:
        writer.writeByte(0);
        break;
      case RatingType.score:
        writer.writeByte(1);
        break;
      case RatingType.emoji:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RatingTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
