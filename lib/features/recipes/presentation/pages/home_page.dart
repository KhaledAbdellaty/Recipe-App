import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/features/recipes/presentation/cubit/recipe_cubit.dart';
import 'package:recipe_app/features/recipes/presentation/widgets/home_app_bar.dart';
import 'package:recipe_app/features/recipes/presentation/widgets/profile_drawer.dart';
import 'package:recipe_app/features/recipes/presentation/widgets/recipe_card.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: ProfileDrawer(),
      body: CustomScrollView(
        slivers: [
          HomeAppBar(scaffoldKey: scaffoldKey),
          BlocBuilder<RecipeCubit, RecipeState>(
            builder: (context, state) {
              if (state is RecipeLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is RecipeError) {
                return SliverFillRemaining(
                  child: Center(child: Text(state.message)),
                );
              }

              if (state is RecipeLoaded) {
                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList.builder(
                    itemCount: state.recipes.length,
                    addAutomaticKeepAlives: true,
                    itemBuilder: (BuildContext context, int index) =>
                        RecipeCard(recipe: state.recipes[index]),
                  ),
                );
              }

              return const SliverFillRemaining(
                child: Center(child: Text('No recipes yet')),
              );
            },
          ),
        ],
      ),
    );
  }
}
