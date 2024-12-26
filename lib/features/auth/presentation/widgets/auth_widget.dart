import 'package:flutter/material.dart';

enum AuthPagesEnum {
  signIn,
  signUp,
}

class AuthWidget extends StatelessWidget {
  final AuthPagesEnum authPagesEnum;
  final GlobalKey<FormState> formKey;
  final List<Widget> widgets;
  const AuthWidget({
    super.key,
    required this.authPagesEnum,
    required this.formKey,
    required this.widgets,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: constraints.maxHeight * 0.1),
                Image.network(
                  "https://i.postimg.cc/nz0YBQcH/Logo-light.png",
                  height: 100,
                ),
                SizedBox(height: constraints.maxHeight * 0.1),
                Text(
                  authPagesEnum.index == 0 ? "Sign In" : "Sign Up",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: constraints.maxHeight * 0.05),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      for (var widget in widgets) widget,
                      const SizedBox(height: 16.0),
                      authPagesEnum.index == 0
                          ? TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot Password?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color!
                                          .withOpacity(0.64),
                                    ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      TextButton(
                        onPressed: () => authPagesEnum.index == 0
                            ? Navigator.pushNamed(context, "/sign_up")
                            : Navigator.pushNamed(context, "/"),
                        child: Text.rich(
                          TextSpan(
                            text: authPagesEnum.index == 0
                                ? "Don’t have an account? "
                                : "Already have an account ",
                            children: [
                              TextSpan(
                                text: authPagesEnum.index == 0
                                    ? "Sign Up"
                                    : "Sign In",
                                style:
                                    const TextStyle(color: Color(0xFF00BF6D)),
                              ),
                            ],
                          ),
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!
                                        .withOpacity(0.64),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
