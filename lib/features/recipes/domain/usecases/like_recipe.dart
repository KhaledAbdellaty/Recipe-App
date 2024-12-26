import 'package:dartz/dartz.dart';
import 'package:recipe_app/features/recipes/data/repositories/recipe_repository_impl.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class LikeRecipeParams {
  final String recipeId;
  final String userId;

  LikeRecipeParams({
    required this.recipeId,
    required this.userId,
  });
}

class LikeRecipeUseCase implements UseCase<void, LikeRecipeParams> {
  final repository = RecipeRepositoryImpl.instance;

  LikeRecipeUseCase._();
  static LikeRecipeUseCase get instance => LikeRecipeUseCase._();

  @override
  Future<Either<Failure, void>> call(LikeRecipeParams params) {
    return repository.likeRecipe(params.recipeId, params.userId);
  }
}
