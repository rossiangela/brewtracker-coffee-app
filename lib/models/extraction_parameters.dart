import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 7)
class ExtractionParameters extends HiveObject {
  @HiveField(0)
  double coffeeAmount;

  @HiveField(1)
  double waterAmount;

  @HiveField(2)
  double temperature;

  @HiveField(3)
  int totalTimeSeconds;

  @HiveField(4)
  bool isCelsius;

  ExtractionParameters({
    required this.coffeeAmount,
    required this.waterAmount,
    required this.temperature,
    required this.totalTimeSeconds,
    this.isCelsius = true,
  });

  double get ratio => waterAmount / coffeeAmount;
}