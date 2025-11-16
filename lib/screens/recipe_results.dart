import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets/recipe_card.dart';

class RecipeResultsScreen extends StatelessWidget {
  final Set<String> selectedIngredients;
  final List<Recipe> loadedRecipes;
  final Set<String> bookmarkedRecipeTitles;
  final void Function(String) onToggleBookmark;
  final VoidCallback? onHelpPressed;

  const RecipeResultsScreen({
    super.key,
    required this.selectedIngredients,
    required this.loadedRecipes,
    required this.bookmarkedRecipeTitles,
    required this.onToggleBookmark,
    this.onHelpPressed,
  });

  List<Recipe> _getFilteredRecipes() {
    if (selectedIngredients.isEmpty) return loadedRecipes;

    return loadedRecipes.where((recipe) {
      return selectedIngredients.every(
        (ingredient) => recipe.ingredients.contains(ingredient),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecipes = _getFilteredRecipes();

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 12.0),
          sliver: filteredRecipes.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No recipes found for your selected ingredients.',
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
                    final recipe = filteredRecipes[index];
                    return RecipeCard(
                      recipe: recipe,
                      isBookmarked: bookmarkedRecipeTitles.contains(
                        recipe.title,
                      ),
                      onToggleBookmark: onToggleBookmark,
                    );
                  }, childCount: filteredRecipes.length),
                ),
        ),
      ],
    );
  }
}
