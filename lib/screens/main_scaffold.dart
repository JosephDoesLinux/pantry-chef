import 'package:flutter/material.dart';

import '../models.dart';
import '../screens/bookmarks_screen.dart';
import '../screens/ingredient_selector.dart';
import '../screens/recipe_results.dart';
import '../utils/app_dialogs.dart';
import '../widgets/app_drawer.dart';

/// Main scaffold widget that manages the navigation and state
class MainScaffold extends StatefulWidget {
  final List<Recipe> recipes;
  final void Function(ThemeMode) onThemeModeChanged;
  final ThemeMode currentThemeMode;

  const MainScaffold({
    super.key,
    required this.recipes,
    required this.onThemeModeChanged,
    required this.currentThemeMode,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  final Set<String> _selectedIngredients = {};
  final Set<String> _bookmarkedRecipeTitles = {};
  final List<int> _navigationHistory = [];
  late PageController _pageController;

  final List<String> _pageTitles = const [
  'Pantry',
  'Recipes',
  'Bookmarks',
];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onIngredientToggled(String ingredientName) {
    setState(() {
      if (_selectedIngredients.contains(ingredientName))
        _selectedIngredients.remove(ingredientName);
      else
        _selectedIngredients.add(ingredientName);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex != index) {
        _navigationHistory.add(_selectedIndex);
        _selectedIndex = index;
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      if (_selectedIndex != index) {
        _navigationHistory.add(_selectedIndex);
        _selectedIndex = index;
      }
    });
  }

  bool _onWillPop() {
    if (_navigationHistory.isNotEmpty) {
      setState(() {
        _selectedIndex = _navigationHistory.removeLast();
        _pageController.animateToPage(
          _selectedIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
      return false; // Don't pop the route
    }
    return true; // Pop the route (exit app)
  }

  void _toggleBookmark(String recipeTitle) {
    setState(() {
      if (_bookmarkedRecipeTitles.contains(recipeTitle)) {
        _bookmarkedRecipeTitles.remove(recipeTitle);
      } else {
        _bookmarkedRecipeTitles.add(recipeTitle);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Each screen provides its own SliverAppBar and counters now.

    final widgetOptions = <Widget>[
      IngredientSelectorScreen(
        selectedIngredients: _selectedIngredients,
        onIngredientToggled: _onIngredientToggled,
        onNavigateToRecipes: () => _onItemTapped(1),
        onHelpPressed: () => showHelpDialog(context),
      ),
      RecipeResultsScreen(
        selectedIngredients: _selectedIngredients,
        loadedRecipes: widget.recipes,
        bookmarkedRecipeTitles: _bookmarkedRecipeTitles,
        onToggleBookmark: _toggleBookmark,
        onHelpPressed: () => showHelpDialog(context),
      ),
      BookmarksScreen(
        loadedRecipes: widget.recipes,
        bookmarkedRecipeTitles: _bookmarkedRecipeTitles,
        onToggleBookmark: _toggleBookmark,
        onHelpPressed: () => showHelpDialog(context),
      ),
    ];

    return PopScope(
      canPop: _navigationHistory.isEmpty,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _onWillPop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // 1. Hamburger button to open the drawer
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          // 2. Dynamic page title
          title: Text(_pageTitles[_selectedIndex]),
          // 3. Help button
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () => showHelpDialog(context), // Invokes the utility
            ),
          ],
          backgroundColor: colorScheme.surfaceContainerHigh,
        ),
        drawer: AppDrawer(
          currentThemeMode: widget.currentThemeMode,
          onThemeModeChanged: widget.onThemeModeChanged,
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: widgetOptions,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          backgroundColor: colorScheme.surfaceContainerHigh,
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.kitchen_outlined),
              selectedIcon: Icon(Icons.kitchen),
              label: 'Pantry',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: 'Recipes',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_outline),
              selectedIcon: Icon(Icons.bookmark),
              label: 'Bookmarks',
            ),
          ],
        ),
      ),
    );
  }
}
