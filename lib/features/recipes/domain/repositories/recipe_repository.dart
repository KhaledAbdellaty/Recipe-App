import 'package:dartz/dartz.dart';
import 'package:recipe_app/core/error/failures.dart';
import 'package:recipe_app/features/recipes/domain/entities/recipe.dart';
import 'package:recipe_app/features/recipes/domain/usecases/create_recipe.dart';
import 'package:recipe_app/features/recipes/domain/usecases/get_recipes.dart';

import '../entities/comment.dart';

abstract class RecipeRepository {
  Future<Either<Failure, List<Recipe>>> getRecipes(GetRecipesParams params);
  Future<Either<Failure, Recipe>> createRecipe(CreateRecipeParams params);
  Future<Either<Failure, void>> rateRecipe(String recipeId, double rating);
  Future<Either<Failure, void>> likeRecipe(String recipeId, String userId);
  Future<Either<Failure, void>> toggleFavorite(String recipeId, String userId);
  Future<Either<Failure, List<Recipe>>> getFavorites(String userId);
  Future<Either<Failure, Comment>> addComment(String recipeId, Comment comment);
  Future<Either<Failure, Comment>> editComment(
      String recipeId, Comment comment);
  Future<Either<Failure, void>> deleteComment(
      String recipeId, String commentId);
}
