import 'package:dartz/dartz.dart';
import 'package:recipe_app/core/error/failures.dart';
import 'package:recipe_app/core/usecases/usecase.dart';
import 'package:recipe_app/features/auth/data/repositories/auth_repository_impl.dart';

class SignOutUseCase implements UseCase<void, NoParams> {
  final repository = AuthRepositoryImpl.instance;

  SignOutUseCase._();
  static SignOutUseCase get instance => SignOutUseCase._();

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.signOut();
  }
}
