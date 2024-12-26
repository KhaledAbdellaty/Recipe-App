import 'package:recipe_app/features/recipes/data/models/like_info_model.dart';
import 'package:recipe_app/features/recipes/domain/entities/comment.dart';
import 'package:recipe_app/features/recipes/domain/entities/like_info.dart';

import '../../domain/entities/recipe.dart';
import 'comment_model.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.title,
    required super.userId,
    required super.authorName,
    required super.category,
    required super.ingredients,
    required super.instructions,
    super.imageUrl,
    super.averageRating = 0.0,
    super.totalRatings = 0,
    required super.likes,
    required super.createdAt,
    required super.comments,
  });

  @override
  RecipeModel copyWith({
    String? id,
    String? title,
    String? userId,
    String? authorName,
    String? category,
    List<String>? ingredients,
    List<String>? instructions,
    List<Comment>? comments,
    String? imageUrl,
    double? averageRating,
    int? totalRatings,
    LikeInfo? likes,
    DateTime? createdAt,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      authorName: authorName ?? this.authorName,
      category: category ?? this.category,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      comments: comments ?? this.comments,
      imageUrl: imageUrl ?? this.imageUrl,
      averageRating: averageRating ?? this.averageRating,
      totalRatings: totalRatings ?? this.totalRatings,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      userId: json['userId'] as String,
      authorName: json['authorName'] as String,
      category: json['category'] as String,
      ingredients: List<String>.from(json['ingredients'] as List),
      instructions: List<String>.from(json['instructions'] as List),
      comments:  (json['comments'] as List?)
              ?.map((c) => CommentModel.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      imageUrl: json['imageUrl'] as String?,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalRatings: json['totalRatings'] as int? ?? 0,
      likes:  LikeInfoModel.fromJson(json['likes'] as Map<String, dynamic>? ?? {}),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'userId': userId,
      'authorName': authorName,
      'category': category,
      'ingredients': ingredients,
      'instructions': instructions,
      'comments': comments,
      'imageUrl': imageUrl,
      'averageRating': averageRating,
      'totalRatings': totalRatings,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory RecipeModel.fromEntity(Recipe recipe) {
    return RecipeModel(
      id: recipe.id,
      title: recipe.title,
      userId: recipe.userId,
      authorName: recipe.authorName,
      category: recipe.category,
      ingredients: recipe.ingredients,
      instructions: recipe.instructions,
      comments: recipe.comments,
      imageUrl: recipe.imageUrl,
      averageRating: recipe.averageRating,
      totalRatings: recipe.totalRatings,
      likes: recipe.likes,
      createdAt: recipe.createdAt,
    );
  }
}
