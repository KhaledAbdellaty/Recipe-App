import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/core/presentation/widgets/credential_input_field.dart';
import 'package:recipe_app/features/auth/presentation/logic/auth_cubit/auth_cubit.dart';
import 'package:recipe_app/features/auth/presentation/widgets/auth_widget.dart';

class SignUpPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit.of(context);
    String? email;
    String? password;
    String? userName;
    return Scaffold(
      body: SafeArea(
        child: AuthWidget(
          authPagesEnum: AuthPagesEnum.signUp,
          formKey: _formKey,
          widgets: [
            CredentialInputField(
              hintText: 'User name',
              keyboardType: TextInputType.name,
              onSaved: (value) {
                userName = value;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: CredentialInputField(
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) {
                  email = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CredentialInputField(
                obscureText: true,
                hintText: 'Password',
                onSaved: (value) {
                  password = value;
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  cubit.signUpUser(email!, password!, userName!);
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
                    return const Text("Sign Up");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
