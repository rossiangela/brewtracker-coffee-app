import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../providers/settings_provider.dart';
import '../../models/enums/rating_type.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAppearanceSection(context),
          const SizedBox(height: 24),
          _buildPreferencesSection(context),
          const SizedBox(height: 24),
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appearance',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Theme'),
                      subtitle: Text(_getThemeModeString(themeProvider.themeMode)),
                      trailing: DropdownButton<ThemeMode>(
                        value: themeProvider.themeMode,
                        onChanged: (value) {
                          if (value != null) {
                            themeProvider.setThemeMode(value);
                          }
                        },
                        items: ThemeMode.values.map((mode) {
                          return DropdownMenuItem(
                            value: mode,
                            child: Text(_getThemeModeString(mode)),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferences',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<SettingsProvider>(
              builder: (context, settingsProvider, child) {
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Rating System'),
                      subtitle: Text(_getRatingTypeString(settingsProvider.ratingType)),
                      trailing: DropdownButton<RatingType>(
                        value: settingsProvider.ratingType,
                        onChanged: (value) {
                          if (value != null) {
                            settingsProvider.setRatingType(value);
                          }
                        },
                        items: RatingType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(_getRatingTypeString(type)),
                          );
                        }).toList(),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Temperature Unit'),
                      subtitle: Text(settingsProvider.isCelsius ? 'Celsius (°C)' : 'Fahrenheit (°F)'),
                      trailing: Switch(
                        value: settingsProvider.isCelsius,
                        onChanged: (value) {
                          settingsProvider.setTemperatureUnit(value);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Image.asset(
                    'assets/logo.png',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.coffee, size: 40);
                    },
                  ),
                  title: const Text('BrewLog'),
                  subtitle: const Text('Version 1.0.0'),
                ),
                const Divider(),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Developer'),
                  subtitle: Text('Coffee Enthusiast'),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Description'),
                  subtitle: Text('A comprehensive app for tracking your coffee journey, discovering new flavors, and perfecting your brewing techniques.'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getThemeModeString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  String _getRatingTypeString(RatingType type) {
    switch (type) {
      case RatingType.stars:
        return 'Stars (1-5)';
      case RatingType.score:
        return 'Score (0-100)';
      case RatingType.emoji:
        return 'Emoji';
    }
  }
}
