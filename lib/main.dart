
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/adapters/coffee_adapter.dart';
import 'data/adapters/recipe_adapter.dart';
import 'data/adapters/tasting_notes_adapter.dart';
import 'data/adapters/extraction_parameters_adapter.dart';
import 'data/adapters/recipe_step_adapter.dart';
import 'data/adapters/roast_level_adapter.dart';
import 'data/adapters/brew_method_adapter.dart';
import 'data/adapters/rating_type_adapter.dart';
import 'models/coffee.dart';
import 'models/recipe.dart';
import 'providers/coffee_provider.dart';
import 'providers/recipe_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/settings_provider.dart';
import 'themes/app_theme.dart';
import 'router/app_router.dart';







void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
Hive.registerAdapter(CoffeeAdapter());
  Hive.registerAdapter(RoastLevelAdapter());
  Hive.registerAdapter(TastingNotesAdapter());
  Hive.registerAdapter(RatingTypeAdapter());
  Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(BrewMethodAdapter());
  Hive.registerAdapter(RecipeStepAdapter());
  Hive.registerAdapter(ExtractionParametersAdapter());
  
  await Hive.openBox<Coffee>('coffees');
  await Hive.openBox<Recipe>('recipes');
  
  final prefs = await SharedPreferences.getInstance();
  
  runApp(BrewLogApp(prefs: prefs));
}

class BrewLogApp extends StatelessWidget {
  final SharedPreferences prefs;
  
  const BrewLogApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => SettingsProvider(prefs)),
        ChangeNotifierProvider(create: (_) => CoffeeProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Brew Log',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}

