import 'package:dartz/dartz.dart';
import 'package:recipe_app/core/error/failures.dart';
import 'package:recipe_app/core/usecases/usecase.dart';
import 'package:recipe_app/features/recipes/data/repositories/recipe_repository_impl.dart';


class RateRecipeParams {
  final String recipeId;
  final double rating;

  RateRecipeParams({
    required this.recipeId,
    required this.rating,
  });
}

class RateRecipeUseCase implements UseCase<void, RateRecipeParams> {
  final repository = RecipeRepositoryImpl.instance;

  RateRecipeUseCase._();
  static RateRecipeUseCase get instance => RateRecipeUseCase._();

  @override
  Future<Either<Failure, void>> call(RateRecipeParams params) {
    return repository.rateRecipe(params.recipeId, params.rating);
  }
}