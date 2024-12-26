import 'package:dartz/dartz.dart';
import 'package:recipe_app/core/error/failures.dart';
import 'package:recipe_app/core/usecases/usecase.dart';
import 'package:recipe_app/features/auth/data/repositories/auth_repository_impl.dart';

import '../entities/user.dart';

class SignUpParams {
  final String email;
  final String username;
  final String password;

  SignUpParams({required this.email, required this.password, required this.username,});
}

class SignUpUseCase implements UseCase<User, SignUpParams> {
  final repository = AuthRepositoryImpl.instance;

  SignUpUseCase._();
  static SignUpUseCase get instance => SignUpUseCase._();

  @override
  Future<Either<Failure, User>> call(SignUpParams params) {
    return repository.signUp(params.email, params.password, params.username);
  }
}
