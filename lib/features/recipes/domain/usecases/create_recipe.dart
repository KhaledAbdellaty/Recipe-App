import 'package:dartz/dartz.dart';
import 'package:recipe_app/core/error/failures.dart';
import 'package:recipe_app/core/usecases/usecase.dart';
import 'package:recipe_app/features/recipes/data/repositories/recipe_repository_impl.dart';

import '../entities/recipe.dart';

class CreateRecipeParams {
  final String title;
  final String? userId;
  final String? authorName;
  final List<String> ingredients;
  final List<String> instructions;
  final String? imageUrl;
  final String category;

  CreateRecipeParams({
     this.userId,
     this.authorName,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.category,
    this.imageUrl,
  });
  CreateRecipeParams copyWith({
   String? userId,
     String? authorName,
    String? title,
    List<String>? ingredients,
    List<String>? instructions,
    String? imageUrl,
    String? category,
  }) {
    return CreateRecipeParams(
      userId: userId ?? this.userId,
      authorName: authorName ?? this.authorName,
        title: title ?? this.title,
        ingredients: ingredients ?? this.ingredients,
        instructions: instructions ?? this.instructions,
        imageUrl: imageUrl ?? this.imageUrl,
        category: category ?? this.category);
  }
}

class CreateRecipeUseCase implements UseCase<Recipe, CreateRecipeParams> {
  final repository = RecipeRepositoryImpl.instance;

  CreateRecipeUseCase._();

  static CreateRecipeUseCase get instance => CreateRecipeUseCase._();

  @override
  Future<Either<Failure, Recipe>> call(CreateRecipeParams params) {
    return repository.createRecipe(params);
  }
}
