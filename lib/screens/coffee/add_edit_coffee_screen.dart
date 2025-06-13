import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../providers/coffee_provider.dart';
import '../../models/coffee.dart';
import '../../models/tasting_notes.dart';
import '../../models/enums/roast_level.dart';
import '../../widgets/common/rating_selector.dart';
import '../../widgets/coffee/tasting_notes_editor.dart';
import '../../utils/image_utils.dart';
class AddEditCoffeeScreen extends StatefulWidget {
  final String? coffeeId;

  const AddEditCoffeeScreen({Key? key, this.coffeeId}) : super(key: key);

  @override
  State<AddEditCoffeeScreen> createState() => _AddEditCoffeeScreenState();
}

class _AddEditCoffeeScreenState extends State<AddEditCoffeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _varietyController = TextEditingController();
  final _originController = TextEditingController();
  final _roasterController = TextEditingController();
  
  RoastLevel _roastLevel = RoastLevel.medium;
  double _rating = 3.0;
  TastingNotes _tastingNotes = TastingNotes(
    sweetness: 3.0,
    acidity: 3.0,
    body: 3.0,
    finish: 3.0,
    notes: '',
  );
  List<String> _images = [];
  bool _isLoading = false;

  bool get _isEditing => widget.coffeeId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadCoffeeData();
    }
  }

  void _loadCoffeeData() {
    final coffee = context.read<CoffeeProvider>().getCoffeeById(widget.coffeeId!);
    if (coffee != null) {
      _nameController.text = coffee.name;
      _varietyController.text = coffee.variety;
      _originController.text = coffee.origin;
      _roasterController.text = coffee.roaster;
      _roastLevel = coffee.roastLevel;
      _rating = coffee.rating;
      _tastingNotes = coffee.tastingNotes;
      _images = List.from(coffee.images);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _varietyController.dispose();
    _originController.dispose();
    _roasterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Coffee' : 'Add Coffee'),
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      context.go('/catalog');
    }
          }, // Fixed navigation
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveCoffee,
            child: _isLoading 
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              _buildRatingSection(),
              const SizedBox(height: 24),
              _buildTastingNotesSection(),
              const SizedBox(height: 24),
              _buildImagesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a coffee name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _roasterController,
          decoration: const InputDecoration(
            labelText: 'Roaster *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the roaster name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _originController,
          decoration: const InputDecoration(
            labelText: 'Origin',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _varietyController,
          decoration: const InputDecoration(
            labelText: 'Variety',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<RoastLevel>(
          value: _roastLevel,
          decoration: const InputDecoration(
            labelText: 'Roast Level',
            border: OutlineInputBorder(),
          ),
          items: RoastLevel.values.map((level) {
            return DropdownMenuItem(
              value: level,
              child: Text(_getRoastLevelString(level)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _roastLevel = value;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rating',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        RatingSelector(
          rating: _rating,
          onRatingChanged: (rating) {
            setState(() {
              _rating = rating;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTastingNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tasting Notes',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TastingNotesEditor(
          tastingNotes: _tastingNotes,
          onChanged: (notes) {
            setState(() {
              _tastingNotes = notes;
            });
          },
        ),
      ],
    );
  }

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Images',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _showImageSourceDialog,
          icon: const Icon(Icons.add_a_photo),
          label: const Text('Add Image'),
        ),
        if (_images.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ImageUtils.buildImageWidget(
                          _images[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () => _removeImage(index),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(24, 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      String? imagePath;
      if (source == ImageSource.camera) {
        imagePath = await ImageUtils.pickImageFromCamera();
      } else {
        imagePath = await ImageUtils.pickImageFromGallery();
      }

      if (imagePath != null) {
        setState(() {
          _images.add(imagePath!);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _saveCoffee() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final coffee = Coffee(
        id: _isEditing ? widget.coffeeId! : const Uuid().v4(),
        name: _nameController.text.trim(),
        variety: _varietyController.text.trim(),
        origin: _originController.text.trim(),
        roastLevel: _roastLevel,
        roaster: _roasterController.text.trim(),
        images: _images,
        tastingNotes: _tastingNotes,
        rating: _rating,
        dateAdded: _isEditing 
            ? context.read<CoffeeProvider>().getCoffeeById(widget.coffeeId!)!.dateAdded
            : DateTime.now(),
      );

      if (_isEditing) {
        await context.read<CoffeeProvider>().updateCoffee(coffee);
      } else {
        await context.read<CoffeeProvider>().addCoffee(coffee);
      }

      if (mounted) {
        context.go('/catalog');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Coffee updated successfully!' : 'Coffee added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving coffee: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
}