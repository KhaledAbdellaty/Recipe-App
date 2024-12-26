import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/recipe.dart';

abstract class RecipeLocalDataSource {
  Future<void> saveRecipe(String recipeId);
  Future<List<Recipe>> getSavedRecipes();
  Future<void> removeSavedRecipe(String recipeId);
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  final SharedPreferences _prefs;
  static const savedRecipesKey = 'SAVED_RECIPES';

  RecipeLocalDataSourceImpl(this._prefs);

  @override
  Future<void> saveRecipe(String recipeId) async {
    final savedRecipes = _prefs.getStringList(savedRecipesKey) ?? [];
    if (!savedRecipes.contains(recipeId)) {
      savedRecipes.add(recipeId);
      await _prefs.setStringList(savedRecipesKey, savedRecipes);
    }
  }

  @override
  Future<List<Recipe>> getSavedRecipes() async {
    final savedRecipes = _prefs.getStringList(savedRecipesKey) ?? [];
    // Note: In a real app, fetch the full recipe data from remote
    // This is just a placeholder implementation
    return [];
  }

  @override
  Future<void> removeSavedRecipe(String recipeId) async {
    final savedRecipes = _prefs.getStringList(savedRecipesKey) ?? [];
    savedRecipes.remove(recipeId);
    await _prefs.setStringList(savedRecipesKey, savedRecipes);
  }
}
