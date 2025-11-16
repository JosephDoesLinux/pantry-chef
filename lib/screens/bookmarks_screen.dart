import 'package:flutter/material.dart';

import '../models.dart';
import '../widgets/recipe_card_with_bookmark.dart';

/// Bookmarks screen showing all saved recipes
class BookmarksScreen extends StatelessWidget {
  final List<Recipe> loadedRecipes;
  final Set<String> bookmarkedRecipeTitles;
  final void Function(String) onToggleBookmark;
  final VoidCallback? onHelpPressed;

  const BookmarksScreen({
    super.key,
    required this.loadedRecipes,
    required this.bookmarkedRecipeTitles,
    required this.onToggleBookmark,
    this.onHelpPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bookmarkedRecipes = loadedRecipes
        .where((recipe) => bookmarkedRecipeTitles.contains(recipe.title))
        .toList();

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 12.0),
          sliver: bookmarkedRecipes.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No bookmarked recipes yet.\nTap the bookmark icon on recipes to save them!',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: 0.7,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return RecipeCardWithBookmark(
                      recipe: bookmarkedRecipes[index],
                      isBookmarked: true,
                      onToggleBookmark: onToggleBookmark,
                    );
                  }, childCount: bookmarkedRecipes.length),
                ),
        ),
      ],
    );
  }
}
