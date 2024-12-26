import 'package:dartz/dartz.dart';
import 'package:recipe_app/core/error/failures.dart';
import 'package:recipe_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:recipe_app/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../../../core/di/injection_container.dart' as di;

class AuthRepositoryImpl implements AuthRepository {
  final remoteDataSource = AuthRemoteDataSourceImpl.instance;
  final localDataSource = AuthLocalDataSourceImpl(di.sl<SharedPreferences>());

  AuthRepositoryImpl._();
  static AuthRepository get instance => AuthRepositoryImpl._();

  @override
  Future<Either<Failure, User>> signIn(String email, String password) async {
    try {
      final user = await remoteDataSource.signIn(email, password);
      final userModel = UserModel.fromEntity(user);
      await localDataSource.cacheUser(userModel);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(
      String email, String password, String username) async {
    try {
      final user = await remoteDataSource.signUp(email, password, username);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      if (user == null) {
        return const Left(AuthFailure('No user logged in'));
      }
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
      String currentPassword, String newPassword) async {
    try {
      await remoteDataSource.changePassword(currentPassword, newPassword);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile(
      String username, String? profilePictureUrl) async {
    try {
      final user =
          await remoteDataSource.updateProfile(username, profilePictureUrl);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
