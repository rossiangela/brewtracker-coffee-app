import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/enums/rating_type.dart';
class SettingsProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  RatingType _ratingType = RatingType.stars;
  bool _isCelsius = true;

  SettingsProvider(this._prefs) {
    _loadSettings();
  }

  RatingType get ratingType => _ratingType;
  bool get isCelsius => _isCelsius;

  void _loadSettings() {
    final ratingTypeIndex = _prefs.getInt('rating_type') ?? 0;
    _ratingType = RatingType.values[ratingTypeIndex];
    _isCelsius = _prefs.getBool('is_celsius') ?? true;
    notifyListeners();
  }

  Future<void> setRatingType(RatingType ratingType) async {
    _ratingType = ratingType;
    await _prefs.setInt('rating_type', ratingType.index);
    notifyListeners();
  }

  Future<void> setTemperatureUnit(bool isCelsius) async {
    _isCelsius = isCelsius;
    await _prefs.setBool('is_celsius', isCelsius);
    notifyListeners();
  }
}