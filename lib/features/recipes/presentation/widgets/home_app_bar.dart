import 'package:flutter/material.dart';
import '../pages/create_recipe.dart';
import 'category_filter.dart';
import 'search_bar.dart';

class HomeAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeAppBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180,
      floating: true,
      pinned: true,
      leadingWidth: 0,
      leading: SizedBox.fromSize(),
      title: const Text("Recipe App"),
      actions: [
        IconButton(
            onPressed: () {
              scaffoldKey.currentState!.showBottomSheet((context) => SizedBox(
                    height: MediaQuery.of(context).size.height / 1.1,
                    width: double.infinity,
                    child: const CreateRecipeScreen(),
                  ));
            },
            icon: const Icon(Icons.add)),
        IconButton(
            onPressed: () {
              scaffoldKey.currentState!.openEndDrawer();
            },
            icon: const Icon(Icons.menu)),
      ],
      flexibleSpace: const FlexibleSpaceBar(
        background: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SearchBarWidget(),
              CategoryFilter(),
            ],
          ),
        ),
      ),
    );
  }
}
