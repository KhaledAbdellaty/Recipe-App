import 'package:dartz/dartz.dart';
import 'package:recipe_app/core/error/failures.dart';
import 'package:recipe_app/core/usecases/usecase.dart';
import 'package:recipe_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:recipe_app/features/auth/domain/entities/user.dart';

class UpdateProfileParams {
  final String username;
  final String? profilePictureUrl;

  UpdateProfileParams({
    required this.username,
    this.profilePictureUrl,
  });
}

class UpdateProfileUseCase implements UseCase<User, UpdateProfileParams> {
  final repository = AuthRepositoryImpl.instance;

  UpdateProfileUseCase._();
  static UpdateProfileUseCase get instance => UpdateProfileUseCase._();

  @override
  Future<Either<Failure, User>> call(UpdateProfileParams params) {
    return repository.updateProfile(
      params.username,
      params.profilePictureUrl,
    );
  }
}
