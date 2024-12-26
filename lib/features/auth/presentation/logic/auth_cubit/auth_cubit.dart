import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recipe_app/core/usecases/usecase.dart';
import 'package:recipe_app/features/auth/domain/entities/user.dart';
import 'package:recipe_app/features/auth/domain/usecases/change_password.dart';
import 'package:recipe_app/features/auth/domain/usecases/sign_out.dart';
import 'package:recipe_app/features/auth/domain/usecases/sign_in.dart';
import 'package:recipe_app/features/auth/domain/usecases/sign_up.dart';
import 'package:recipe_app/features/auth/domain/usecases/update_profile.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit of(context) => BlocProvider.of(context);
  final SignInUseCase _signIn = SignInUseCase.instance;
  final SignUpUseCase _signUp = SignUpUseCase.instance;
  final SignOutUseCase _signOut = SignOutUseCase.instance;
  final UpdateProfileUseCase _updateProfile = UpdateProfileUseCase.instance;
  final ChangePasswordUseCase _changePassword = ChangePasswordUseCase.instance;
  User? user;
  Future<void> signInUser(String email, String password) async {
    emit(AuthLoading());

    final result = await _signIn(SignInParams(
      email: email,
      password: password,
    ));

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) {
        this.user = user;
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> signUpUser(
      String email, String password, String userName) async {
    emit(AuthLoading());

    final result = await _signUp(
        SignUpParams(email: email, password: password, username: userName));

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) {
        log(user.email);
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> signOutUser() async {
    emit(AuthLoading());

    final result = await _signOut(NoParams());

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthInitial()),
    );
  }

  Future<void> updateUserProfile(
      String username, String? profilePictureUrl) async {
    if (state is! AuthAuthenticated) return;

    emit(AuthLoading());

    final result = await _updateProfile(UpdateProfileParams(
      username: username,
      profilePictureUrl: profilePictureUrl,
    ));

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> changePassword(String oldPass, newPass) async {
    final result = await _changePassword(
        ChangePasswordParams(currentPassword: oldPass, newPassword: newPass));

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthSuccess()),
    );
  }
}
