import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipes/presentation/cubit/recipe_cubit.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = RecipeCubit.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search recipes...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (query) {
          if (query.length >= 2) {
            cubit.search(query);
          } else if (query.isEmpty) {
            cubit.clearSearch(context);
          }
        },
      ),
    );
  }
}
