import 'package:dartz/dartz.dart';
import 'package:recipe_app/features/recipes/data/repositories/recipe_repository_impl.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class ToggleFavoriteParams {
  final String recipeId;
  final String userId;

  ToggleFavoriteParams({
    required this.recipeId,
    required this.userId,
  });
}

class ToggleFavoriteUseCase implements UseCase<void, ToggleFavoriteParams> {
  final repository = RecipeRepositoryImpl.instance;

  ToggleFavoriteUseCase._();

  static ToggleFavoriteUseCase get instance => ToggleFavoriteUseCase._();

  @override
  Future<Either<Failure, void>> call(ToggleFavoriteParams params) {
    return repository.toggleFavorite(params.recipeId, params.userId);
  }
}
