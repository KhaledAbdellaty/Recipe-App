import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/core/services/notification/notification_service.dart';
import 'package:recipe_app/core/usecases/pick_image.dart';
import 'package:recipe_app/core/usecases/upload_image.dart';
import 'package:recipe_app/features/auth/domain/entities/user.dart';
import 'package:recipe_app/features/auth/domain/usecases/update_profile.dart';
import 'package:recipe_app/features/auth/presentation/logic/auth_cubit/auth_cubit.dart';
import 'package:recipe_app/features/recipes/domain/usecases/add_comment.dart';
import 'package:recipe_app/features/recipes/domain/usecases/delete_comment.dart';
import 'package:recipe_app/features/recipes/domain/usecases/edit_comment.dart';
import 'package:recipe_app/features/recipes/domain/usecases/get_favorite.dart';
import 'package:recipe_app/features/recipes/domain/usecases/like_recipe.dart';
import 'package:recipe_app/features/recipes/domain/usecases/rate_recipe.dart';
import 'package:recipe_app/features/recipes/domain/usecases/toggle_favorite.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/services/notification/notification_type.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/recipe.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_recipe.dart';
import '../../domain/usecases/get_recipes.dart';

part 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final _createRecipe = CreateRecipeUseCase.instance;
  final _getRecipes = GetRecipesUseCase.instance;
  final _pickImage = PickImageUseCase.instance;
  final _uploadImage = UploadImageUseCase.instance;
  final _likeRecipe = LikeRecipeUseCase.instance;
  final _addComment = AddCommentUseCase.instance;
  final _editComment = EditCommentUseCase.instance;
  final _deleteComment = DeleteCommentUseCase.instance;
  final _toggleFavorite = ToggleFavoriteUseCase.instance;
  final _getFavorite = GetFavoritesUseCase.instance;
  final _updateProfile = UpdateProfileUseCase.instance;
  final _rateRecipe = RateRecipeUseCase.instance;

  final _notificationService = NotificationService.instance;

  XFile? imageFile;
  RecipeCubit() : super(RecipeInitial());
  static RecipeCubit of(context) => BlocProvider.of(context);
  String selectedCategory = "All";
  final categories = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Dessert',
    'Snacks'
  ];
  List<Recipe> recipes = [];
  List<Comment> comments = [];
  final userLikes = [];
  User? user;

  Future<void> loadRecipes(BuildContext context, {String? category}) async {
    user ??= AuthCubit.of(context).user;
    emit(RecipeLoading());
    final result = await _getRecipes(GetRecipesParams(category: category));

    result.fold(
      (failure) => emit(RecipeError(failure.message)),
      (recipes) {
        selectedCategory = category ?? selectedCategory;
        this.recipes = recipes;
        emit(RecipeLoaded(recipes));
      },
    );
  }

  Future<void> createNewRecipe(
      BuildContext context, CreateRecipeParams params) async {
    emit(RecipeLoading());
    await _uploadImage(UploadImageParams(path: 'recipe', image: imageFile!))
        .then((value) =>
            value.fold((l) => emit(RecipeError(l.message)), (r) async {
              params = params.copyWith(
                  userId: user!.id, authorName: user!.username, imageUrl: r);
              final result = await _createRecipe(params);
              result.fold(
                (failure) => emit(RecipeError(failure.message)),
                (recipe) => loadRecipes(context),
              );
            }));
  }

  Future<void> uploadProfileImage() async {
    emit(RecipeLoading());
    await _uploadImage(UploadImageParams(path: 'users', image: imageFile!))
        .then((value) =>
            value.fold((l) => emit(RecipeError(l.message)), (r) async {
              await _updateProfile(UpdateProfileParams(
                      username: user!.username, profilePictureUrl: r))
                  .then((value) => value.fold(
                      (l) => emit(RecipeError(l.message)), (r) => user = r));
            }));
  }

  Future<void> updateProfile(String userName) async {
    await _updateProfile(UpdateProfileParams(username: userName)).then(
        (value) => value.fold((l) => RecipeError(l.message), (r) => user = r));
  }

  Future<void> search(String query) async {
    emit(RecipeLoading());
    List<Recipe> resualt = [];
    recipes.map((e) {
      if (e.title.toLowerCase().contains(query.toLowerCase())) {
        resualt.add(e);
      }
    });
    emit(RecipeLoaded(resualt));
  }

  void clearSearch(BuildContext context) {
    loadRecipes(context);
  }

  pickImage({required ImageSource source}) async {
    final ll = await _pickImage(PickImageParams(source: source));

    ll.fold((l) => emit(RecipeError(l.message)), (r) {
      imageFile = r;
      emit(RecipeImageLoaded(File(imageFile!.path)));
    });
  }

  Future<void> rateRecipe(String recipeId, double rating) async {
    final currentState = state;
    if (currentState is RecipeLoaded) {
      final result = await _rateRecipe(RateRecipeParams(
        recipeId: recipeId,
        rating: rating,
      ));

      result.fold(
        (failure) => emit(RecipeError(failure.message)),
        (_) async {
          final updatedRecipes = currentState.recipes.map((recipe) {
            if (recipe.id == recipeId) {
              final newTotalRatings = recipe.totalRatings + 1;
              final newAverageRating =
                  ((recipe.averageRating * recipe.totalRatings) + rating) /
                      newTotalRatings;

              return recipe.copyWith(
                averageRating: newAverageRating,
                totalRatings: newTotalRatings,
              );
            }
            return recipe;
          }).toList();
          final recipe =
              currentState.recipes.firstWhere((r) => r.id == recipeId);
          await _notificationService.sendRecipeNotification(
            recipeId: recipeId,
            authorId: recipe.userId,
            type: NotificationType.rating,
            triggerUserId: user!.id,
          );
          emit(RecipeLoaded(updatedRecipes));
        },
      );
    }
  }

  Future<void> toggleLike(BuildContext context, String recipeId) async {
    final currentState = state;
    if (currentState is RecipeLoaded) {
      final result = await _likeRecipe(LikeRecipeParams(
        recipeId: recipeId,
        userId: user!.id,
      ));

      result.fold(
        (failure) => emit(RecipeError(failure.message)),
        (_) async {
          final recipe =
              currentState.recipes.firstWhere((r) => r.id == recipeId);
          // Send notification to recipe author
          await _notificationService.sendRecipeNotification(
            recipeId: recipeId,
            authorId: recipe.userId,
            type: NotificationType.like,
            triggerUserId: user!.id,
          );
        },
      );
    }
  }

  Future<void> togglefavorite(String recipeId) async {
    final currentState = state;
    if (currentState is RecipeLoaded) {
      final result = await _toggleFavorite(ToggleFavoriteParams(
        recipeId: recipeId,
        userId: user!.id,
      ));

      result.fold(
        (failure) => emit(RecipeError(failure.message)),
        (_) => null,
      );
    }
  }

  Future<void> getfavorites() async {
    final result = await _getFavorite(GetFavoritesParams(
      userId: user!.id,
    ));

    result.fold(
      (failure) => emit(RecipeError(failure.message)),
      (recipes) {
        user = user!.copyWith(favoriteRecipes: recipes);
      },
    );
  }

  bool isRecipeFavorited(String recipeId) {
    final currentState = state;
    if (currentState is RecipeLoaded) {
      final recipe = currentState.recipes.firstWhere((r) => r.id == recipeId);
      return user!.favoriteRecipes.contains(recipe);
    }
    return false;
  }

  bool isRecipeLiked(String recipeId) {
    final currentState = state;
    if (currentState is RecipeLoaded) {
      final recipe = currentState.recipes.firstWhere((r) => r.id == recipeId);
      return recipe.isLikedBy(user!.id);
    }
    return false;
  }

  Future<void> addComment(String recipeId, String content) async {
    final currentState = state;
    if (currentState is RecipeLoaded) {
      final result = await _addComment(AddCommentParams(
        recipeId: recipeId,
        comment: Comment(
          id: const Uuid().v4(),
          userId: user!.id,
          userName: user!.username,
          content: content,
          createdAt: DateTime.now(),
        ),
      ));
      result.fold(
        (failure) => emit(RecipeError(failure.message)),
        (newComment) async {
          final updatedRecipes = currentState.recipes.map((recipe) {
            if (recipe.id == recipeId) {
              return recipe.copyWith(
                comments: [newComment, ...recipe.comments],
              );
            }
            return recipe;
          }).toList();
          final recipe =
              currentState.recipes.firstWhere((r) => r.id == recipeId);

          // Send notification to recipe author
          await _notificationService.sendRecipeNotification(
            recipeId: recipeId,
            authorId: recipe.userId,
            type: NotificationType.comment,
            triggerUserId: user!.id,
            content: content,
          );
          emit(RecipeLoaded(updatedRecipes));
        },
      );
    }
  }

  Future<void> editComment(
      String recipeId, String commentId, String content) async {
    final currentState = state;
    if (currentState is RecipeLoaded) {
      final result = await _editComment(EditCommentParams(
        recipeId: recipeId,
        comment: Comment(
          id: commentId,
          userId: user!.id,
          userName: user!.username,
          content: content,
          createdAt: DateTime.now(),
        ),
      ));

      result.fold(
        (failure) => emit(RecipeError(failure.message)),
        (updatedComment) {
          final updatedRecipes = currentState.recipes.map((recipe) {
            if (recipe.id == recipeId) {
              final updatedComments = recipe.comments.map((comment) {
                return comment.id == commentId ? updatedComment : comment;
              }).toList();
              return recipe.copyWith(comments: updatedComments);
            }
            return recipe;
          }).toList();
          emit(RecipeLoaded(updatedRecipes));
        },
      );
    }
  }

  Future<void> deleteComment(String recipeId, String commentId) async {
    final currentState = state;
    if (currentState is RecipeLoaded) {
      final result = await _deleteComment(DeleteCommentParams(
        recipeId: recipeId,
        commentId: commentId,
      ));

      result.fold(
        (failure) => emit(RecipeError(failure.message)),
        (_) {
          final updatedRecipes = currentState.recipes.map((recipe) {
            if (recipe.id == recipeId) {
              final updatedComments = recipe.comments
                  .where((comment) => comment.id != commentId)
                  .toList();
              return recipe.copyWith(comments: updatedComments);
            }
            return recipe;
          }).toList();
          emit(RecipeLoaded(updatedRecipes));
        },
      );
    }
  }

  bool canModifyComment(String commentUserId) => commentUserId == user!.id;
}
