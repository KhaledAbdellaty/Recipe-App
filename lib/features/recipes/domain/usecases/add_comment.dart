import 'package:dartz/dartz.dart';
import 'package:recipe_app/features/recipes/data/repositories/recipe_repository_impl.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/comment.dart';

class AddCommentParams {
  final String recipeId;
  final Comment comment;

  AddCommentParams({
    required this.recipeId,
    required this.comment,
  });
}

class AddCommentUseCase implements UseCase<Comment, AddCommentParams> {
  final repository = RecipeRepositoryImpl.instance;

  AddCommentUseCase._();
  static AddCommentUseCase get instance => AddCommentUseCase._();

  @override
  Future<Either<Failure, Comment>> call(AddCommentParams params) {
    return repository.addComment(params.recipeId, params.comment);
  }
}
