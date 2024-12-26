import 'package:equatable/equatable.dart';

import 'comment.dart';
import 'like_info.dart';

class Recipe extends Equatable {
  final String id;
  final String title;
  final String userId;
  final String authorName;
  final String category;
  final List<String> ingredients;
  final List<String> instructions;
  final String? imageUrl;
  final double averageRating;
  final int totalRatings;
  final LikeInfo? likes;
  final List<Comment> comments;
  final DateTime createdAt;

  const Recipe({
    required this.id,
    required this.title,
    required this.userId,
    required this.authorName,
    required this.ingredients,
    required this.instructions,
    required this.category,
    required this.comments,
    this.imageUrl,
    this.averageRating = 0.0,
    this.totalRatings = 0,
    this.likes,
    required this.createdAt,
  });
  bool isLikedBy(String userId) =>
      likes!.userIds.isNotEmpty ? likes!.userIds.contains(userId) : false;

  Recipe copyWith({
    String? id,
    String? title,
    String? userId,
    String? authorName,
    String? category,
    List<String>? ingredients,
    List<String>? instructions,
    String? imageUrl,
    double? averageRating,
    int? totalRatings,
    LikeInfo? likes,
    List<Comment>? comments,
    DateTime? createdAt,
  }) {
    return Recipe(
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

  @override
  List<Object?> get props => [
        id,
        title,
        userId,
        authorName,
        category,
        ingredients,
        instructions,
        comments,
        imageUrl,
        averageRating,
        totalRatings,
        likes,
        createdAt,
      ];
}
