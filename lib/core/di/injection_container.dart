import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/core/services/image_picker_service.dart';
import 'package:recipe_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:recipe_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:recipe_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:recipe_app/features/recipes/data/datasources/recipe_local_datasource.dart';
import 'package:recipe_app/features/recipes/data/datasources/recipe_remote_datasource.dart';
import 'package:recipe_app/features/recipes/data/repositories/recipe_repository_impl.dart';
import 'package:recipe_app/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:recipe_app/features/recipes/domain/usecases/create_recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/recipes/domain/usecases/get_recipes.dart';
import '../../features/recipes/domain/usecases/rate_recipe.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(() => ImagePicker());
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => ImagePickerService.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseMessaging.instance);
  sl.registerLazySingleton(() => NotificationService(sl(), sl()));

  // Local Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl.instance,
  );
  sl.registerLazySingleton<RecipeRemoteDataSource>(
    () => RecipeRemoteDataSourceImpl.instance,
  );
  sl.registerLazySingleton<RecipeLocalDataSource>(
    () => RecipeLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl.instance);
  sl.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl.instance,
  );

  // Use Cases
  sl.registerLazySingleton(() => CreateRecipeUseCase.instance);
  sl.registerLazySingleton(() => GetRecipesUseCase.instance);
  sl.registerLazySingleton(() => RateRecipe(sl()));

  // Cubits
  // sl.registerFactory(
  //   () => RecipeCubit(
  //     createRecipe: sl(),
  //     getRecipes: sl(),
  //     rateRecipe: sl(),
  //   ),
  // );

  // Previous registrations...
}
