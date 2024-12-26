import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:recipe_app/features/recipes/presentation/cubit/recipe_cubit.dart';
import '../../domain/entities/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    String content = "";
    final cubit = RecipeCubit.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recipe.imageUrl != null)
            AspectRatio(
              aspectRatio: 1.5,
              child: CachedNetworkImage(
                imageUrl: recipe.imageUrl!,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    LikeButton(
                      onTap: (isLiked) async {
                        cubit.togglefavorite(recipe.id);
                        return !isLiked;
                      },
                      isLiked: cubit.isRecipeFavorited(recipe.id),
                      likeBuilder: (isFavorite) {
                        final color = isFavorite ? Colors.green : Colors.grey;
                        return Icon(
                          Icons.bookmark,
                          color: color,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'by ${recipe.authorName}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            recipe.averageRating.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LikeButton(
                      onTap: (isLiked) async {
                        cubit.toggleLike(context, recipe.id);
                        return !isLiked;
                      },
                      isLiked: cubit.isRecipeLiked(recipe.id),
                      likeCount: recipe.likes != null ? recipe.likes!.count : 0,
                      likeBuilder: (isLiked) {
                        final color = isLiked ? Colors.red : Colors.grey;
                        return Icon(
                          Icons.favorite,
                          color: color,
                        );
                      },
                      countBuilder: (likeCount, isLiked, text) {
                        final color = isLiked ? Colors.black : Colors.grey;
                        return Text.rich(
                          TextSpan(text: text, children: const [
                            TextSpan(text: " Likes"),
                          ]),
                          style: TextStyle(
                            color: color,
                          ),
                        );
                      },
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.chat,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text.rich(
                          TextSpan(
                            text: recipe.comments.length.toString(),
                            children: const [TextSpan(text: " Comments")],
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Wrap(
                    direction: Axis.vertical,
                    children: List.generate(
                      recipe.comments.length,
                      (index) {
                        final comment = recipe.comments[index];
                        return Card(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment.userName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  comment.content,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
                TextFormField(
                  onChanged: (value) => content = value,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () => cubit.addComment(recipe.id, content),
                          icon: const Icon(Icons.send))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
