import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/features/recipes/data/models/like_info_model.dart';
import 'package:recipe_app/features/recipes/domain/usecases/get_recipes.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/recipe.dart';
import '../models/comment_model.dart';
import '../models/recipe_model.dart';

abstract class RecipeRemoteDataSource {
  Future<List<Recipe>> getRecipes(GetRecipesParams params);
  Future<Recipe> createRecipe(Recipe recipe);
  Future<void> rateRecipe(String recipeId, double rating);
  Future<void> toggleLike(String recipeId, String userId);
  Future<void> toggleFavorite(String recipeId, String userId);
  Future<List<RecipeModel>> getFavorites(String userId);
  Future<Comment> addComment(String recipeId, Comment comment);
  Future<Comment> editComment(String recipeId, Comment comment);
  Future<void> deleteComment(String recipeId, String commentId);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final _firestore = FirebaseFirestore.instance;

  RecipeRemoteDataSourceImpl._();
  static RecipeRemoteDataSourceImpl get instance =>
      RecipeRemoteDataSourceImpl._();

  @override
  Future<List<Recipe>> getRecipes(GetRecipesParams params) async {
    final query = _firestore.collection('recipes');
    final QuerySnapshot<Map<String, dynamic>> snapshot;
    if (params.category != null && params.category != 'All') {
      snapshot =
          await query.where('category', isEqualTo: params.category).get();
    } else {
      snapshot = await query.get();
    }
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return RecipeModel.fromJson(data);
    }).toList();
  }

  @override
  Future<Recipe> createRecipe(Recipe recipe) async {
    final recipeModel = RecipeModel.fromEntity(recipe);
    final docRef =
        await _firestore.collection('recipes').add(recipeModel.toJson());
    return recipeModel.copyWith(id: docRef.id);
  }

  @override
  Future<void> rateRecipe(String recipeId, double rating) async {
    final docRef = _firestore.collection('recipes').doc(recipeId);
    final doc = await docRef.get();
    final data = doc.data()!;

    final currentTotal = data['averageRating'] * data['totalRatings'];
    final newTotalRatings = data['totalRatings'] + 1;
    final newAverageRating = (currentTotal + rating) / newTotalRatings;

    await docRef.update({
      'averageRating': newAverageRating,
      'totalRatings': newTotalRatings,
    });
  }

  @override
  Future<void> toggleLike(String recipeId, String userId) async {
    final recipeRef = _firestore.collection('recipes').doc(recipeId);

    await _firestore.runTransaction((transaction) async {
      final recipeDoc = await transaction.get(recipeRef);
      final data = recipeDoc.data() ?? {};

      final likes =
          LikeInfoModel.fromJson(data['likes'] as Map<String, dynamic>? ?? {});
      final userIds = List<String>.from(likes.userIds);

      if (userIds.contains(userId)) {
        userIds.remove(userId);
      } else {
        userIds.add(userId);
      }

      transaction.update(recipeRef, {
        'likes': LikeInfoModel(
          count: userIds.length,
          userIds: userIds,
        ).toJson(),
      });
    });
  }

  @override
  Future<List<RecipeModel>> getFavorites(String userId) async {
    final userFavorites = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favoriteRecipes')
        .get();

    final recipeIds = userFavorites.docs.map((doc) => doc.id).toList();

    if (recipeIds.isEmpty) return [];

    final recipesSnapshot = await _firestore
        .collection('recipes')
        .where(FieldPath.documentId, whereIn: recipeIds)
        .get();

    return Future.wait(
      recipesSnapshot.docs.map((doc) async {
        final data = doc.data();
        data['id'] = doc.id;
        return RecipeModel.fromJson(data);
      }),
    );
  }

  @override
  Future<void> toggleFavorite(String recipeId, String userId) async {
    final favoriteRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('favoriteRecipes')
        .doc(recipeId);

    final doc = await favoriteRef.get();

    if (doc.exists) {
      await favoriteRef.delete();
    } else {
      await favoriteRef.set({
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<Comment> addComment(String recipeId, Comment comment) async {
    final com = CommentModel.fromEntity(comment);

    await _firestore.collection('recipes').doc(recipeId).update({
      'comments': FieldValue.arrayUnion([com.toJson()])
    });

    return com;
  }

  @override
  Future<Comment> editComment(String recipeId, Comment comment) async {
    final commentRef = _firestore
        .collection('recipes')
        .doc(recipeId)
        .collection('comments')
        .doc(comment.id);

    await commentRef.update({
      'content': comment.content,
      'editedAt': FieldValue.serverTimestamp(),
    });

    final updatedComment = await commentRef.get();
    final data = updatedComment.data()!;
    data['id'] = comment.id;

    return CommentModel.fromJson(data);
  }

  @override
  Future<void> deleteComment(String recipeId, String commentId) async {
    await _firestore
        .collection('recipes')
        .doc(recipeId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }
}
