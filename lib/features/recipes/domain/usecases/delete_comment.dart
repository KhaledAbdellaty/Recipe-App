import 'package:dartz/dartz.dart';
import 'package:recipe_app/features/recipes/data/repositories/recipe_repository_impl.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteCommentParams {
  final String recipeId;
  final String commentId;

  DeleteCommentParams({
    required this.recipeId,
    required this.commentId,
  });
}
class DeleteCommentUseCase implements UseCase<void, DeleteCommentParams> {
  final repository = RecipeRepositoryImpl.instance;

  DeleteCommentUseCase._();

  static DeleteCommentUseCase get instance => DeleteCommentUseCase._();

  @override
  Future<Either<Failure, void>> call(DeleteCommentParams params) {
    return repository.deleteComment(params.recipeId, params.commentId);
  }
}
