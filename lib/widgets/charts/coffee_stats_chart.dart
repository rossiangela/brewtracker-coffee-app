import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/coffee.dart';
import '../../models/enums/roast_level.dart';
class CoffeeStatsChart extends StatelessWidget {
  final List<Coffee> coffees;

  const CoffeeStatsChart({Key? key, required this.coffees}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (coffees.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coffee Statistics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: _buildRoastLevelChart(context),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildRatingDistributionChart(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoastLevelChart(BuildContext context) {
    final roastCounts = <RoastLevel, int>{};
    for (final coffee in coffees) {
      roastCounts[coffee.roastLevel] = (roastCounts[coffee.roastLevel] ?? 0) + 1;
    }

    return Column(
      children: [
        Text(
          'Roast Levels',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: PieChart(
            PieChartData(
              sections: roastCounts.entries.map((entry) {
                final color = _getRoastLevelColor(entry.key);
                return PieChartSectionData(
                  value: entry.value.toDouble(),
                  title: '${entry.value}',
                  color: color,
                  radius: 50,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
              centerSpaceRadius: 30,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingDistributionChart(BuildContext context) {
    final ratingBuckets = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final coffee in coffees) {
      final bucket = coffee.rating.round();
      ratingBuckets[bucket] = (ratingBuckets[bucket] ?? 0) + 1;
    }

    return Column(
      children: [
        Text(
          'Rating Distribution',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: ratingBuckets.values.reduce((a, b) => a > b ? a : b).toDouble() + 1,
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}★',
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: ratingBuckets.entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.toDouble(),
                      color: Colors.amber,
                      width: 16,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Color _getRoastLevelColor(RoastLevel roastLevel) {
    switch (roastLevel) {
      case RoastLevel.light:
        return Colors.amber[200]!;
      case RoastLevel.medium:
        return Colors.brown[300]!;
      case RoastLevel.mediumDark:
        return Colors.brown[600]!;
      case RoastLevel.dark:
        return Colors.brown[900]!;
    }
  }
}

