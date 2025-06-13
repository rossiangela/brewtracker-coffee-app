import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/recipe.dart';
import '../models/enums/brew_method.dart';
class RecipeProvider extends ChangeNotifier {
  final Box<Recipe> _recipeBox = Hive.box<Recipe>('recipes');
  List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];
  String _searchQuery = '';
  BrewMethod? _filterBrewMethod;

  List<Recipe> get recipes => _filteredRecipes;
  String get searchQuery => _searchQuery;
  BrewMethod? get filterBrewMethod => _filterBrewMethod;

  RecipeProvider() {
    _loadRecipes();
  }

  void _loadRecipes() {
    _recipes = _recipeBox.values.toList();
    _applyFilters();
  }

  void _applyFilters() {
    _filteredRecipes = _recipes.where((recipe) {
      bool matchesSearch = _searchQuery.isEmpty ||
          recipe.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          recipe.notes.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          recipe.tags.any((tag) => 
              tag.toLowerCase().contains(_searchQuery.toLowerCase()));

      bool matchesBrewMethod = _filterBrewMethod == null ||
          recipe.brewMethod == _filterBrewMethod;

      return matchesSearch && matchesBrewMethod;
    }).toList();

    _filteredRecipes.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    notifyListeners();
  }

  void searchRecipes(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByBrewMethod(BrewMethod? brewMethod) {
    _filterBrewMethod = brewMethod;
    _applyFilters();
  }

  void clearFilters() {
    _searchQuery = '';
    _filterBrewMethod = null;
    _applyFilters();
  }

  Future<void> addRecipe(Recipe recipe) async {
    await _recipeBox.put(recipe.id, recipe);
    _loadRecipes();
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await _recipeBox.put(recipe.id, recipe);
    _loadRecipes();
  }

  Future<void> deleteRecipe(String id) async {
    await _recipeBox.delete(id);
    _loadRecipes();
  }

  Recipe? getRecipeById(String id) {
    return _recipeBox.get(id);
  }

  List<Recipe> getRecipesByBrewMethod(BrewMethod brewMethod) {
    return _recipes.where((recipe) => recipe.brewMethod == brewMethod).toList();
  }
}