import 'package:recipe_app/features/recipes/data/models/recipe_model.dart';
import 'package:recipe_app/features/recipes/domain/entities/recipe.dart';

import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    super.profilePictureUrl,
    super.favoriteRecipes,
  });

  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? profilePictureUrl,
    List<Recipe>? favoriteRecipes,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      favoriteRecipes: favoriteRecipes ?? this.favoriteRecipes
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      favoriteRecipes: (json['favoriteRecipes'] as List?)
              ?.map((c) => RecipeModel.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'profilePictureUrl': profilePictureUrl,
      'favoriteRecipes': favoriteRecipes,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      username: user.username,
      profilePictureUrl: user.profilePictureUrl,
      favoriteRecipes: user.favoriteRecipes
    );
  }
}
