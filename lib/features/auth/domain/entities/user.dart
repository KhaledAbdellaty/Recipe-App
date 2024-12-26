import 'package:equatable/equatable.dart';
import 'package:recipe_app/features/recipes/domain/entities/recipe.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String username;
  final String? profilePictureUrl;
  final List<Recipe> favoriteRecipes;
  
  const User({
    required this.id,
    required this.email,
    required this.username,
    this.profilePictureUrl,
    this.favoriteRecipes = const [],
  });
  
  User copyWith({
    String? id,
    String? email,
    String? username,
    String? profilePictureUrl,
    List<Recipe>? favoriteRecipes,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      favoriteRecipes: favoriteRecipes ?? this.favoriteRecipes,
    );
  }
  @override
  List<Object?> get props => [id, email, username, profilePictureUrl, favoriteRecipes];
}