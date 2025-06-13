import 'package:go_router/go_router.dart';

import '../screens/home/home_screen.dart';
import '../screens/coffee/catalog_screen.dart';
import '../screens/coffee/coffee_detail_screen.dart';
import '../screens/coffee/add_edit_coffee_screen.dart';
import '../screens/recipe/recipes_screen.dart';
import '../screens/recipe/add_edit_recipe_screen.dart';
import '../screens/timer/timer_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/common/main_wrapper.dart';

final GoRouter router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainWrapper(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/catalog',
          builder: (context, state) => const CatalogScreen(),
        ),
        GoRoute(
          path: '/recipes',
          builder: (context, state) => const RecipesScreen(),
        ),
        GoRoute(
          path: '/timer',
          builder: (context, state) => const TimerScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/coffee/:id',
      builder: (context, state) => CoffeeDetailScreen(
        coffeeId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/add-coffee',
      builder: (context, state) => const AddEditCoffeeScreen(),
    ),
    GoRoute(
      path: '/edit-coffee/:id',
      builder: (context, state) => AddEditCoffeeScreen(
        coffeeId: state.pathParameters['id'],
      ),
    ),
    GoRoute(
      path: '/add-recipe',
      builder: (context, state) => const AddEditRecipeScreen(),
    ),
    GoRoute(
      path: '/edit-recipe/:id',
      builder: (context, state) => AddEditRecipeScreen(
        recipeId: state.pathParameters['id'],
      ),
    ),
  ],
);
