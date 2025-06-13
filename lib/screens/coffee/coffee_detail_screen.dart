import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../providers/coffee_provider.dart';
import '../../models/coffee.dart';
import '../../models/enums/roast_level.dart';
import '../../widgets/common/rating_display.dart';
import '../../widgets/coffee/tasting_notes_display.dart';
import '../../utils/image_utils.dart';
class CoffeeDetailScreen extends StatelessWidget {
  final String coffeeId;

  const CoffeeDetailScreen({Key? key, required this.coffeeId}) : super(key: key);





  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeProvider>(
      builder: (context, coffeeProvider, child) {
        final coffee = coffeeProvider.getCoffeeById(coffeeId);
        
        if (coffee == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: (){
                  log("kkk");
                   if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
       log("kkk");
      context.go('/catalog');
    }
                }, // Fixed navigation
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: const Center(
              child: Text('Coffee not found'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(coffee.name),
            leading: IconButton(
                onPressed: (){
                  log("kkk");
                   if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
       log("kkk");
      context.go('/catalog');
    }
                }, // Fixed navigation
              icon: const Icon(Icons.arrow_back),
            ),
            actions: [
              IconButton(
                onPressed: () => context.go('/edit-coffee/$coffeeId'),
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () => _showDeleteDialog(context, coffee),
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageCarousel(coffee),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBasicInfo(context, coffee),
                      const SizedBox(height: 24),
                      _buildRatingSection(context, coffee),
                      const SizedBox(height: 24),
                      _buildTastingNotesSection(context, coffee),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageCarousel(Coffee coffee) {
    if (coffee.images.isEmpty) {
      return Container(
        height: 250,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.coffee, size: 64),
        ),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 250,
        viewportFraction: 1.0,
        enableInfiniteScroll: coffee.images.length > 1,
        autoPlay: coffee.images.length > 1,
        autoPlayInterval: const Duration(seconds: 3),
      ),
      items: coffee.images.map((imagePath) {
        return Container(
          width: double.infinity,
          child: ImageUtils.buildImageWidget(
            imagePath,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBasicInfo(BuildContext context, Coffee coffee) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          coffee.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildInfoRow(context, 'Roaster', coffee.roaster),
        _buildInfoRow(context, 'Origin', coffee.origin),
        _buildInfoRow(context, 'Variety', coffee.variety),
        _buildInfoRow(context, 'Roast Level', _getRoastLevelString(coffee.roastLevel)),
        _buildInfoRow(context, 'Date Added', _formatDate(coffee.dateAdded)),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection(BuildContext context, Coffee coffee) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rating',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        RatingDisplay(rating: coffee.rating),
      ],
    );
  }

  Widget _buildTastingNotesSection(BuildContext context, Coffee coffee) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tasting Notes',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TastingNotesDisplay(tastingNotes: coffee.tastingNotes),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, Coffee coffee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Coffee'),
        content: Text('Are you sure you want to delete "${coffee.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              // Delete associated images
              for (final imagePath in coffee.images) {
                await ImageUtils.deleteImage(imagePath);
              }
              
              await context.read<CoffeeProvider>().deleteCoffee(coffee.id);
              if (context.mounted) {
                Navigator.of(context).pop();
                context.go('/catalog');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Coffee deleted successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _getRoastLevelString(RoastLevel roastLevel) {
    switch (roastLevel) {
      case RoastLevel.light:
        return 'Light';
      case RoastLevel.medium:
        return 'Medium';
      case RoastLevel.mediumDark:
        return 'Medium Dark';
      case RoastLevel.dark:
        return 'Dark';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
