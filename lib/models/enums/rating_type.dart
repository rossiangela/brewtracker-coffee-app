import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 3)
enum RatingType {
  @HiveField(0)
  stars,
  @HiveField(1)
  score,
  @HiveField(2)
  emoji,
}
