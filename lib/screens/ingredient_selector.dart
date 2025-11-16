import 'package:flutter/material.dart';
import '../models.dart';

class IngredientSelectorScreen extends StatefulWidget {
  final Set<String> selectedIngredients;
  final Function(String) onIngredientToggled;
  final VoidCallback onNavigateToRecipes;
  final VoidCallback? onHelpPressed;

  const IngredientSelectorScreen({
    super.key,
    required this.selectedIngredients,
    required this.onIngredientToggled,
    required this.onNavigateToRecipes,
    this.onHelpPressed,
  });

  @override
  State<IngredientSelectorScreen> createState() =>
      _IngredientSelectorScreenState();
}

class _IngredientSelectorScreenState extends State<IngredientSelectorScreen> {
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<IngredientCategory> _getFilteredCategories() {
    if (_searchQuery.isEmpty) {
      return ingredientCategories;
    }

    return ingredientCategories
        .map((category) {
          final filteredIngredients = category.ingredients
              .where(
                (ingredient) =>
                    ingredient.name.toLowerCase().contains(_searchQuery),
              )
              .toList();
          return IngredientCategory(category.name, filteredIngredients);
        })
        .where((category) => category.ingredients.isNotEmpty)
        .toList();
  }

@override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // 1. Define the SearchBar widget with its padding
    final searchBarWidget = Padding(
      padding: const EdgeInsets.all(16.0),
      child: SearchBar(
        controller: _searchController,
        hintText: 'Search or add ingredients...',
        leading: const Icon(Icons.search),
        onTap: () {},
      ),
    );

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // --- NEW: Use SliverPersistentHeader for the floating SearchBar ---
            SliverPersistentHeader(
              // `pinned: true` makes it stick after the main AppBar
              pinned: true, 
              delegate: _SearchBarDelegate(
                child: searchBarWidget,
                backgroundColor: colorScheme.background, // Use your app's main background color
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._getFilteredCategories().map((category) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: category.ingredients.map((ingredient) {
                              final isSelected = widget.selectedIngredients
                                  .contains(ingredient.name);
                              return FilterChip(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                label: Text(ingredient.name),
                                avatar: Icon(ingredient.icon),
                                selected: isSelected,
                                onSelected: (bool selected) {
                                  widget.onIngredientToggled(ingredient.name);
                                },
                                selectedColor: Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.onSecondaryContainer
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    }).toList(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 24,
          left: 0,
          right: 0,
          child: Center(
            child: FilledButton.icon(
              onPressed: widget.selectedIngredients.isEmpty
                  ? null
                  : widget.onNavigateToRecipes,
              icon: const Icon(Icons.search),
              label: const Text('Find Recipes', style: TextStyle(fontSize: 16)),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


// In ./screens/ingredient_selector.dart

// Helper class for the persistent SearchBar
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  // This color is crucial to prevent content from showing through the header when scrolling
  final Color backgroundColor; 

  _SearchBarDelegate({required this.child, required this.backgroundColor});

  // The SearchBar will not shrink or expand
  @override
  double get minExtent => maxExtent;

  // The estimated height of the SearchBar + its padding (16.0 top + 16.0 bottom + SearchBar height)
  // SearchBar typically has a height of about 48-56, so 80.0 is a safe estimate.
  @override
  double get maxExtent => 80.0; 

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // The Container provides a solid background for the floating bar
    return Container(
      color: backgroundColor, 
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _SearchBarDelegate oldDelegate) {
    // Only rebuild if the content or background color changes
    return oldDelegate.child != child || oldDelegate.backgroundColor != backgroundColor;
  }
}