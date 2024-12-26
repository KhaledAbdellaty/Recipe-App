import 'package:flutter/material.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
  
  String get appTitle;
  String get emailHint;
  String get passwordHint;
  String get loginButton;
  String get signupButton;
  String get recipeTitle;
  String get ingredients;
  String get instructions;
  String get addRecipe;
}