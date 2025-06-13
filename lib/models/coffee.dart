import 'package:hive/hive.dart';

import 'enums/roast_level.dart';
import 'tasting_notes.dart';

@HiveType(typeId: 0)
class Coffee extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String variety;

  @HiveField(3)
  String origin;

  @HiveField(4)
  RoastLevel roastLevel;

  @HiveField(5)
  String roaster;

  @HiveField(6)
  List<String> images;

  @HiveField(7)
  TastingNotes tastingNotes;

  @HiveField(8)
  double rating;

  @HiveField(9)
  DateTime dateAdded;

  Coffee({
    required this.id,
    required this.name,
    required this.variety,
    required this.origin,
    required this.roastLevel,
    required this.roaster,
    required this.images,
    required this.tastingNotes,
    required this.rating,
    required this.dateAdded,
  });
}
