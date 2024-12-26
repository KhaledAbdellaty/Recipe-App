import 'package:dartz/dartz.dart';
import 'package:recipe_app/features/recipes/data/repositories/recipe_repository_impl.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/comment.dart';

class EditCommentParams {
  final String recipeId;

  final Comment comment;

  EditCommentParams({
    required this.recipeId,
    required this.comment,
  });
}

class EditCommentUseCase implements UseCase<Comment, EditCommentParams> {
  final repository = RecipeRepositoryImpl.instance;

  EditCommentUseCase._();

  static EditCommentUseCase get instance => EditCommentUseCase._();

  @override
  Future<Either<Failure, Comment>> call(EditCommentParams params) {
    return repository.editComment(
      params.recipeId,
      params.comment,
    );
  }
}
