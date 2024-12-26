import 'package:dartz/dartz.dart';
import 'package:recipe_app/core/error/failures.dart';
import 'package:recipe_app/core/usecases/usecase.dart';
import 'package:recipe_app/features/auth/data/repositories/auth_repository_impl.dart';

import '../entities/user.dart';

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}

class SignInUseCase implements UseCase<User, SignInParams> {
  final repository = AuthRepositoryImpl.instance;

  SignInUseCase._();
  static SignInUseCase get instance => SignInUseCase._();

  @override
  Future<Either<Failure, User>> call(SignInParams params) {
    return repository.signIn(params.email, params.password);
  }
}
