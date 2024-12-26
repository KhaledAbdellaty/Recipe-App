import 'package:dartz/dartz.dart';
import 'package:recipe_app/core/error/failures.dart';
import 'package:recipe_app/core/usecases/usecase.dart';
import 'package:recipe_app/features/recipes/data/repositories/recipe_repository_impl.dart';
import '../entities/recipe.dart';

class GetRecipesParams {
  final String? category;
  final String? searchQuery;
  final int page;
  final int limit;

  GetRecipesParams({
    this.category,
    this.searchQuery,
    this.page = 1,
    this.limit = 10,
  });
}

class GetRecipesUseCase implements UseCase<List<Recipe>, GetRecipesParams> {
  final repository = RecipeRepositoryImpl.instance;
  GetRecipesUseCase._();
  static GetRecipesUseCase get instance => GetRecipesUseCase._();

  @override
  Future<Either<Failure, List<Recipe>>> call(GetRecipesParams params) {
    return repository.getRecipes(params);
  }
}
