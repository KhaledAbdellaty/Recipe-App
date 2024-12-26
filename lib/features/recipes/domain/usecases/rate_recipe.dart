import 'package:dartz/dartz.dart';
import 'package:recipe_app/core/error/failures.dart';
import 'package:recipe_app/core/usecases/usecase.dart';
import 'package:recipe_app/features/recipes/domain/repositories/recipe_repository.dart';


class RateRecipeParams {
  final String recipeId;
  final double rating;

  RateRecipeParams({
    required this.recipeId,
    required this.rating,
  });
}

class RateRecipe implements UseCase<void, RateRecipeParams> {
  final RecipeRepository repository;

  RateRecipe(this.repository);

  @override
  Future<Either<Failure, void>> call(RateRecipeParams params) {
    return repository.rateRecipe(params.recipeId, params.rating);
  }
}