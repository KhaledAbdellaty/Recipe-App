import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:recipe_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:recipe_app/features/recipes/presentation/cubit/recipe_cubit.dart';
import 'package:recipe_app/features/recipes/presentation/pages/create_recipe.dart';
import 'package:recipe_app/features/recipes/presentation/pages/home_page.dart';

class RouteManager {
  RouteManager._();
  static Route? onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (context) => SignInPage(),
        );
      case "/sign_up":
        return MaterialPageRoute(
          builder: (context) => SignUpPage(),
        );
      case "/home":
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => RecipeCubit()
              ..loadRecipes(context)
              ..getfavorites(),
            child: HomePage(),
          ),
        );
      case "/create_recipe":
        return MaterialPageRoute(
          builder: (context) => CreateRecipeScreen(),
        );
    }
    return null;
  }
}
