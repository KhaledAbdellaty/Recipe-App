part of 'recipe_cubit.dart';

abstract class RecipeState extends Equatable {
  @override
  List<Object> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;

  RecipeLoaded(this.recipes);

  @override
  List<Object> get props => [recipes];
}

class FavoriteRecipeLoaded extends RecipeState {
  final List<Recipe> recipes;

  FavoriteRecipeLoaded(this.recipes);

  @override
  List<Object> get props => [recipes];
}

class RecipeImageLoaded extends RecipeState {
  final File image;

  RecipeImageLoaded(this.image);

  @override
  List<Object> get props => [image];
}

class ProfileUpdated extends RecipeState {
  final User user;
  ProfileUpdated(this.user);
  @override
  List<Object> get props => [user];
}

class RecipeError extends RecipeState {
  final String message;

  RecipeError(this.message);

  @override
  List<Object> get props => [message];
}
