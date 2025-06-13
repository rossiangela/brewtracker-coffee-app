import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../providers/recipe_provider.dart';
import '../../models/recipe.dart';
import '../../models/recipe_step.dart';
import '../../models/extraction_parameters.dart';
import '../../models/enums/brew_method.dart';
import '../../widgets/recipe/extraction_parameters_editor.dart';
class AddEditRecipeScreen extends StatefulWidget {
  final String? recipeId;

  const AddEditRecipeScreen({Key? key, this.recipeId}) : super(key: key);

  @override
  State<AddEditRecipeScreen> createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();
  
  BrewMethod _brewMethod = BrewMethod.pourOver;
  List<RecipeStep> _steps = [];
  ExtractionParameters _parameters = ExtractionParameters(
    coffeeAmount: 20.0,
    waterAmount: 300.0,
    temperature: 93.0,
    totalTimeSeconds: 240,
  );

  bool get _isEditing => widget.recipeId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadRecipeData();
    } else {
      _loadDefaultSteps();
    }
  }

  void _loadRecipeData() {
    final recipe = context.read<RecipeProvider>().getRecipeById(widget.recipeId!);
    if (recipe != null) {
      _nameController.text = recipe.name;
      _notesController.text = recipe.notes;
      _tagsController.text = recipe.tags.join(', ');
      _brewMethod = recipe.brewMethod;
      _steps = List.from(recipe.steps);
      _parameters = recipe.parameters;
    }
  }

  void _loadDefaultSteps() {
    switch (_brewMethod) {
      case BrewMethod.pourOver:
        _steps = [
          RecipeStep(instruction: 'Rinse filter and preheat', durationSeconds: 30, order: 0),
          RecipeStep(instruction: 'Add coffee and create well', durationSeconds: 10, order: 1),
          RecipeStep(instruction: 'Bloom with 50ml water', durationSeconds: 30, order: 2),
          RecipeStep(instruction: 'Pour remaining water in circles', durationSeconds: 120, order: 3),
          RecipeStep(instruction: 'Wait for drip to finish', durationSeconds: 60, order: 4),
        ];
        break;
      case BrewMethod.espresso:
        _steps = [
          RecipeStep(instruction: 'Grind coffee fine', durationSeconds: 15, order: 0),
          RecipeStep(instruction: 'Dose and level', durationSeconds: 10, order: 1),
          RecipeStep(instruction: 'Tamp with 30lbs pressure', durationSeconds: 5, order: 2),
          RecipeStep(instruction: 'Extract shot', durationSeconds: 28, order: 3),
        ];
        break;
      case BrewMethod.frenchPress:
        _steps = [
          RecipeStep(instruction: 'Add coarse ground coffee', durationSeconds: 10, order: 0),
          RecipeStep(instruction: 'Pour hot water and stir', durationSeconds: 30, order: 1),
          RecipeStep(instruction: 'Steep', durationSeconds: 240, order: 2),
          RecipeStep(instruction: 'Press slowly', durationSeconds: 30, order: 3),
        ];
        break;
      case BrewMethod.aeroPress:
        _steps = [
          RecipeStep(instruction: 'Insert filter and rinse', durationSeconds: 20, order: 0),
          RecipeStep(instruction: 'Add coffee and shake level', durationSeconds: 10, order: 1),
          RecipeStep(instruction: 'Pour water and stir', durationSeconds: 30, order: 2),
          RecipeStep(instruction: 'Steep', durationSeconds: 60, order: 3),
          RecipeStep(instruction: 'Press down slowly', durationSeconds: 30, order: 4),
        ];
        break;
      case BrewMethod.coldBrew:
        _steps = [
          RecipeStep(instruction: 'Combine coffee and cold water', durationSeconds: 60, order: 0),
          RecipeStep(instruction: 'Stir well', durationSeconds: 30, order: 1),
          RecipeStep(instruction: 'Steep in refrigerator', durationSeconds: 43200, order: 2),
          RecipeStep(instruction: 'Filter concentrate', durationSeconds: 300, order: 3),
        ];
        break;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Recipe' : 'Add Recipe'),
        leading: IconButton(  onPressed: () {
            if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      context.go('/catalog');
    }
          }, icon: Icon(Icons.arrow_back), ),
        actions: [
          TextButton(
            onPressed: _saveRecipe,
            child: const Text('Save'),
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
              _buildParametersSection(),
              const SizedBox(height: 24),
              _buildStepsSection(),
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
            labelText: 'Recipe Name *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a recipe name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<BrewMethod>(
          value: _brewMethod,
          decoration: const InputDecoration(
            labelText: 'Brew Method',
            border: OutlineInputBorder(),
          ),
          items: BrewMethod.values.map((method) {
            return DropdownMenuItem(
              value: method,
              child: Text(_getBrewMethodString(method)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _brewMethod = value;
                if (!_isEditing) {
                  _loadDefaultSteps();
                }
              });
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _tagsController,
          decoration: const InputDecoration(
            labelText: 'Tags (comma separated)',
            border: OutlineInputBorder(),
            hintText: 'smooth, bright, fruity',
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'Notes',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildParametersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Extraction Parameters',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ExtractionParametersEditor(
          parameters: _parameters,
          onChanged: (parameters) {
            setState(() {
              _parameters = parameters;
            });
          },
        ),
      ],
    );
  }

  Widget _buildStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recipe Steps',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: _addStep,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _steps.length,
          onReorder: _reorderSteps,
          itemBuilder: (context, index) {
            final step = _steps[index];
            return Card(
              key: ValueKey(index),
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text(step.instruction),
                subtitle: Text('${step.durationSeconds}s'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _editStep(index),
                      icon: const Icon(Icons.edit, size: 20),
                    ),
                    IconButton(
                      onPressed: () => _removeStep(index),
                      icon: const Icon(Icons.delete, size: 20),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _addStep() {
    _showStepDialog(null);
  }

  void _editStep(int index) {
    _showStepDialog(index);
  }

  void _showStepDialog(int? index) {
    final isEditing = index != null;
    final instructionController = TextEditingController();
    final durationController = TextEditingController();

    if (isEditing) {
      instructionController.text = _steps[index].instruction;
      durationController.text = _steps[index].durationSeconds.toString();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Step' : 'Add Step'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: instructionController,
              decoration: const InputDecoration(
                labelText: 'Instruction',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(
                labelText: 'Duration (seconds)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final instruction = instructionController.text.trim();
              final duration = int.tryParse(durationController.text) ?? 0;

              if (instruction.isNotEmpty && duration > 0) {
                setState(() {
                  if (isEditing) {
                    _steps[index] = RecipeStep(
                      instruction: instruction,
                      durationSeconds: duration,
                      order: index,
                    );
                  } else {
                    _steps.add(RecipeStep(
                      instruction: instruction,
                      durationSeconds: duration,
                      order: _steps.length,
                    ));
                  }
                });
                Navigator.of(context).pop();
              }
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
      // Update order for remaining steps
      for (int i = 0; i < _steps.length; i++) {
        _steps[i] = RecipeStep(
          instruction: _steps[i].instruction,
          durationSeconds: _steps[i].durationSeconds,
          order: i,
        );
      }
    });
  }

  void _reorderSteps(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final step = _steps.removeAt(oldIndex);
      _steps.insert(newIndex, step);
      
      // Update order for all steps
      for (int i = 0; i < _steps.length; i++) {
        _steps[i] = RecipeStep(
          instruction: _steps[i].instruction,
          durationSeconds: _steps[i].durationSeconds,
          order: i,
        );
      }
    });
  }

  void _saveRecipe() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final tags = _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    final recipe = Recipe(
      id: _isEditing ? widget.recipeId! : const Uuid().v4(),
      name: _nameController.text,
      brewMethod: _brewMethod,
      steps: _steps,
      parameters: _parameters,
      notes: _notesController.text,
      dateCreated: _isEditing 
          ? context.read<RecipeProvider>().getRecipeById(widget.recipeId!)!.dateCreated
          : DateTime.now(),
      tags: tags,
    );

    if (_isEditing) {
      await context.read<RecipeProvider>().updateRecipe(recipe);
    } else {
      await context.read<RecipeProvider>().addRecipe(recipe);
    }

    if (context.mounted) {
      context.go('/recipes');
    }
  }

  String _getBrewMethodString(BrewMethod method) {
    switch (method) {
      case BrewMethod.espresso:
        return 'Espresso';
      case BrewMethod.pourOver:
        return 'Pour Over';
      case BrewMethod.frenchPress:
        return 'French Press';
      case BrewMethod.aeroPress:
        return 'AeroPress';
      case BrewMethod.coldBrew:
        return 'Cold Brew';
    }
  }
}
