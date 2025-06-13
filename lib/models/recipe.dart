import 'package:hive/hive.dart';

import 'enums/brew_method.dart';
import 'recipe_step.dart';
import 'extraction_parameters.dart';
@HiveType(typeId: 4)
class Recipe extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  BrewMethod brewMethod;

  @HiveField(3)
  List<RecipeStep> steps;

  @HiveField(4)
  ExtractionParameters parameters;

  @HiveField(5)
  String notes;

  @HiveField(6)
  DateTime dateCreated;

  @HiveField(7)
  List<String> tags;

  Recipe({
    required this.id,
    required this.name,
    required this.brewMethod,
    required this.steps,
    required this.parameters,
    required this.notes,
    required this.dateCreated,
    required this.tags,
  });
}