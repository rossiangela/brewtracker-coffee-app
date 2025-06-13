import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 6)
class RecipeStep extends HiveObject {
  @HiveField(0)
  String instruction;

  @HiveField(1)
  int durationSeconds;

  @HiveField(2)
  int order;

  RecipeStep({
    required this.instruction,
    required this.durationSeconds,
    required this.order,
  });
}


