import 'package:dartz/dartz.dart';
import 'package:recipe_app/features/recipes/data/repositories/recipe_repository_impl.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/recipe.dart';

class GetFavoritesParams {
  final String userId;

  GetFavoritesParams({required this.userId});
}

class GetFavoritesUseCase implements UseCase<List<Recipe>, GetFavoritesParams> {
  final  repository = RecipeRepositoryImpl.instance;

  GetFavoritesUseCase._();
  static GetFavoritesUseCase get instance => GetFavoritesUseCase._();

  @override
  Future<Either<Failure, List<Recipe>>> call(GetFavoritesParams params) {
    return repository.getFavorites(params.userId);
  }
}
