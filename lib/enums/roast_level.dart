import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 1)
enum RoastLevel {
  @HiveField(0)
  light,
  @HiveField(1)
  medium,
  @HiveField(2)
  mediumDark,
  @HiveField(3)
  dark,
}