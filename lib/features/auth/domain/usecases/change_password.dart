import 'package:dartz/dartz.dart';
import 'package:recipe_app/core/error/failures.dart';
import 'package:recipe_app/core/usecases/usecase.dart';
import 'package:recipe_app/features/auth/data/repositories/auth_repository_impl.dart';

class ChangePasswordParams {
  final String currentPassword;
  final String newPassword;

  ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });
}

class ChangePasswordUseCase implements UseCase<void, ChangePasswordParams> {
  final repository = AuthRepositoryImpl.instance;

  ChangePasswordUseCase._();
  static ChangePasswordUseCase get instance => ChangePasswordUseCase._();

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) {
    return repository.changePassword(
      params.currentPassword,
      params.newPassword,
    );
  }
}
