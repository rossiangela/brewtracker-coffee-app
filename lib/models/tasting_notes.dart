import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 2)
class TastingNotes extends HiveObject {
  @HiveField(0)
  double sweetness;

  @HiveField(1)
  double acidity;

  @HiveField(2)
  double body;

  @HiveField(3)
  double finish;

  @HiveField(4)
  String notes;

  TastingNotes({
    required this.sweetness,
    required this.acidity,
    required this.body,
    required this.finish,
    required this.notes,
  });
}
