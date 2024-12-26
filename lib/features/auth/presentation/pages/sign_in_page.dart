import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/core/presentation/widgets/credential_input_field.dart';
import 'package:recipe_app/features/auth/domain/usecases/sign_in.dart';
import 'package:recipe_app/features/auth/presentation/logic/auth_cubit/auth_cubit.dart';
import 'package:recipe_app/features/auth/presentation/widgets/auth_widget.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final signIn = SignInUseCase.instance;

  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit.of(context);
    String? email;
    String? password;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushNamed(context, '/home');
        } 
      },
      child: AuthWidget(
        authPagesEnum: AuthPagesEnum.signIn,
        formKey: _formKey,
        widgets: [
          CredentialInputField(
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            onSaved: (ema) {
              email = ema;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: CredentialInputField(
              obscureText: true,
              hintText: 'Password',
              onSaved: (passaword) {
                password = passaword;
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                cubit.signInUser(email!, password!);
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFF00BF6D),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: const StadiumBorder(),
            ),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text("Sign In");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
