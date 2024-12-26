import 'package:dartz/dartz.dart';
import 'package:recipe_app/core/error/failures.dart';
import 'package:recipe_app/features/recipes/data/datasources/recipe_local_datasource.dart';
import 'package:recipe_app/features/recipes/data/datasources/recipe_remote_datasource.dart';
import 'package:recipe_app/features/recipes/domain/entities/comment.dart';
import 'package:recipe_app/features/recipes/domain/entities/recipe.dart';
import 'package:recipe_app/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:recipe_app/features/recipes/domain/usecases/create_recipe.dart';
import 'package:recipe_app/features/recipes/domain/usecases/get_recipes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/di/injection_container.dart' as di;

class RecipeRepositoryImpl implements RecipeRepository {
  final remoteDataSource = RecipeRemoteDataSourceImpl.instance;
  final localDataSource = RecipeLocalDataSourceImpl(di.sl<SharedPreferences>());

  RecipeRepositoryImpl._();
  static RecipeRepositoryImpl get instance => RecipeRepositoryImpl._();

  @override
  Future<Either<Failure, List<Recipe>>> getRecipes(
      GetRecipesParams params) async {
    try {
      final recipes = await remoteDataSource.getRecipes(params);
      return Right(recipes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Recipe>> createRecipe(
      CreateRecipeParams params) async {
    try {
      final recipe = await remoteDataSource.createRecipe(Recipe(
        id: '',
        title: params.title,
        ingredients: params.ingredients,
        instructions: params.instructions,
        imageUrl: params.imageUrl,
        userId: params.userId!,
        authorName: params.authorName!,
        category: params.category,
        comments: const [],
        createdAt: DateTime.now(),
      ));
      return Right(recipe);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rateRecipe(
      String recipeId, double rating) async {
    try {
      await remoteDataSource.rateRecipe(recipeId, rating);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> likeRecipe(
    String recipeId,
    String userId,
  ) async {
    try {
      await remoteDataSource.toggleLike(recipeId, userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(
      String recipeId, String userId) async {
    try {
      await remoteDataSource.toggleFavorite(recipeId, userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getFavorites(String userId) async {
    try {
      final recipes = await remoteDataSource.getFavorites(userId);
      return Right(recipes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Comment>> addComment(
    String recipeId,
    Comment comment,
  ) async {
    try {
      final com = await remoteDataSource.addComment(recipeId, comment);
      return Right(com);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Comment>> editComment(
    String recipeId,
    Comment comment,
  ) async {
    try {
      final com = await remoteDataSource.editComment(
        recipeId,
        comment,
      );
      return Right(com);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(
      String recipeId, String commentId) async {
    try {
      await remoteDataSource.deleteComment(recipeId, commentId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
