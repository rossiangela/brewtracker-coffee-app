import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 5)
enum BrewMethod {
  @HiveField(0)
  espresso,
  @HiveField(1)
  pourOver,
  @HiveField(2)
  frenchPress,
  @HiveField(3)
  aeroPress,
  @HiveField(4)
  coldBrew,
}