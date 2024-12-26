import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/core/presentation/widgets/image_picker_bottom_sheet.dart';
import 'package:recipe_app/features/recipes/presentation/cubit/recipe_cubit.dart';
import '../../domain/usecases/create_recipe.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _ingredients = <String>[];
  final _instructions = <String>[];
  String _selectedCategory = 'Breakfast';

  final _categories = ['Breakfast', 'Lunch', 'Dinner', 'Dessert', 'Snacks'];

  @override
  Widget build(BuildContext context) {
    final cubit = RecipeCubit.of(context);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        leading: SizedBox.fromSize(),
        title: const Text('Create Recipe'),
        actions: [
          OutlinedButton(
              onPressed: () => _submitRecipe(cubit), child: Text("Post")),
          IconButton(
              onPressed: () => Navigator.pop(context), icon: Icon(Icons.close))
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Recipe Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(style: BorderStyle.solid)),
              child: Center(
                child: BlocBuilder<RecipeCubit, RecipeState>(
                  buildWhen: (previous, current) =>
                      previous.runtimeType != current.runtimeType,
                  builder: (context, state) {
                    return IconButton(
                        onPressed: () => showBottomSheet(
                              context: context,
                              builder: (context) => ImagePickerBottomSheet(
                                onSourceSelected: (source) {
                                  cubit.pickImage(source: source);
                                },
                              ),
                            ),
                        icon: state is RecipeImageLoaded
                            ? Image.file(state.image)
                            : state is RecipeLoading
                                ? const CircularProgressIndicator()
                                : const Icon(Icons.image));
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildIngredientsList(),
            const SizedBox(height: 16),
            _buildInstructionsList(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _submitRecipe(cubit),
              child: const Text('Create Recipe'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ingredients',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _ingredients.length + 1,
          itemBuilder: (context, index) {
            if (index == _ingredients.length) {
              return TextButton(
                onPressed: () => _addIngredient(context),
                child: const Text('Add Ingredient'),
              );
            }
            return ListTile(
              title: Text(_ingredients[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _ingredients.removeAt(index);
                  });
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInstructionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Instructions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _instructions.length + 1,
          itemBuilder: (context, index) {
            if (index == _instructions.length) {
              return TextButton(
                onPressed: () => _addInstruction(context),
                child: const Text('Add Step'),
              );
            }
            return ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(_instructions[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _instructions.removeAt(index);
                  });
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _addIngredient(BuildContext context) async {
    final controller = TextEditingController();
    final ingredient = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Ingredient'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter ingredient',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (ingredient != null && ingredient.isNotEmpty) {
      setState(() {
        _ingredients.add(ingredient);
      });
    }
  }

  Future<void> _addInstruction(BuildContext context) async {
    final controller = TextEditingController();
    final instruction = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Instruction'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter instruction',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (instruction != null && instruction.isNotEmpty) {
      setState(() {
        _instructions.add(instruction);
      });
    }
  }

  void _submitRecipe(RecipeCubit cubit) {
    if (_formKey.currentState?.validate() ?? false) {
      if (_ingredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one ingredient')),
        );
        return;
      }

      if (_instructions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one instruction')),
        );
        return;
      }
      if (_instructions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one instruction')),
        );
        return;
      }

      cubit.createNewRecipe(
        context,
        CreateRecipeParams(
          title: _titleController.text,
          ingredients: _ingredients,
          instructions: _instructions,
          category: _selectedCategory,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
