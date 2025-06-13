import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/recipe.dart';

class RecipeComparisonChart extends StatelessWidget {
  final List<Recipe> recipes;

  const RecipeComparisonChart({Key? key, required this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recipes.length < 2) {
      return Center(
        child: Text(
          'Select at least 2 recipes to compare',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recipe Comparison',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 20,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < recipes.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                recipes[index].name.length > 10
                                    ? '${recipes[index].name.substring(0, 10)}...'
                                    : recipes[index].name,
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _createBarGroups(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(context),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups() {
    return List.generate(recipes.length, (index) {
      final recipe = recipes[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: recipe.parameters.ratio,
            color: _getColorForIndex(index),
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLegend(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: recipes.asMap().entries.map((entry) {
        final index = entry.key;
        final recipe = entry.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _getColorForIndex(index),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              recipe.name,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );
      }).toList(),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }
}
