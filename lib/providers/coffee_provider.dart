import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/coffee.dart';
import '../models/enums/roast_level.dart';
class CoffeeProvider extends ChangeNotifier {
  final Box<Coffee> _coffeeBox = Hive.box<Coffee>('coffees');
  List<Coffee> _coffees = [];
  List<Coffee> _filteredCoffees = [];
  String _searchQuery = '';
  RoastLevel? _filterRoastLevel;
  double _minRating = 0;

  List<Coffee> get coffees => _filteredCoffees;
  String get searchQuery => _searchQuery;
  RoastLevel? get filterRoastLevel => _filterRoastLevel;
  double get minRating => _minRating;

  CoffeeProvider() {
    _loadCoffees();
  }

  void _loadCoffees() {
    _coffees = _coffeeBox.values.toList();
    _applyFilters();
  }

  void _applyFilters() {
    _filteredCoffees = _coffees.where((coffee) {
      bool matchesSearch = _searchQuery.isEmpty ||
          coffee.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          coffee.roaster.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          coffee.origin.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesRoast = _filterRoastLevel == null ||
          coffee.roastLevel == _filterRoastLevel;

      bool matchesRating = coffee.rating >= _minRating;

      return matchesSearch && matchesRoast && matchesRating;
    }).toList();

    _filteredCoffees.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    notifyListeners();
  }

  void searchCoffees(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByRoastLevel(RoastLevel? roastLevel) {
    _filterRoastLevel = roastLevel;
    _applyFilters();
  }

  void filterByRating(double minRating) {
    _minRating = minRating;
    _applyFilters();
  }

  void clearFilters() {
    _searchQuery = '';
    _filterRoastLevel = null;
    _minRating = 0;
    _applyFilters();
  }

  Future<void> addCoffee(Coffee coffee) async {
    await _coffeeBox.put(coffee.id, coffee);
    _loadCoffees();
  }

  Future<void> updateCoffee(Coffee coffee) async {
    await _coffeeBox.put(coffee.id, coffee);
    _loadCoffees();
  }

  Future<void> deleteCoffee(String id) async {
    await _coffeeBox.delete(id);
    _loadCoffees();
  }

  Coffee? getCoffeeById(String id) {
    return _coffeeBox.get(id);
  }
}
