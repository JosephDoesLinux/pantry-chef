# Pantry Chef 👨‍🍳

A modern Material 3 Flutter application that helps you discover recipes based on ingredients you have on hand.

## Overview

**Pantry Chef** is an ingredient-based recipe discovery app built with Flutter and Dart. Select the ingredients available in your pantry, and the app will suggest delicious recipes you can prepare with those ingredients.

### Features

- **🔍 Ingredient Selection**: Browse and select from a comprehensive list of ingredients organized by category (Proteins, Vegetables, Fruits, Pantry Staples, etc.)
- **🔎 Smart Search**: Filter ingredients with a searchable interface to quickly find what you're looking for
- **📋 Recipe Discovery**: Get instant recipe suggestions based on your selected ingredients
- **❤️ Bookmarks**: Save your favorite recipes for quick access later
- **🎨 Material Design 3**: Beautiful, modern UI with dynamic theming
- **💾 Local Data**: Recipes loaded from assets for offline accessibility

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart (included with Flutter)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/JosephDoesLinux/lets_get_cookin.git
   cd lets_get_cookin
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                    # App entry point and theme configuration
├── models.dart                  # Data models (Recipe, Ingredient, IngredientCategory)
├── screens/
│   ├── main_scaffold.dart      # Main navigation scaffold
│   ├── ingredient_selector.dart # Ingredient selection screen with search
│   ├── recipe_results.dart      # Recipe suggestions display
│   └── bookmarks_screen.dart    # Saved recipes screen
├── widgets/                     # Reusable UI components
└── utils/                       # Utility functions and helpers
```

## How It Works

1. **Select Ingredients**: Browse categorized ingredients or use the search bar to find specific items
2. **Find Recipes**: Tap "Find Recipes" to see all recipes that can be made with your selected ingredients
3. **Save Favorites**: Bookmark recipes you love for quick access
4. **Switch Themes**: Toggle between light, dark, and system themes

## Technologies Used

- **Framework**: Flutter
- **Language**: Dart
- **Design**: Material Design 3
- **State Management**: StatefulWidget

## Credits

**Pantry Chef** was developed by:
- [Joseph Abou Antoon](https://github.com/JosephDoesLinux)
- [Zeina Al Homsi](https://github.com/ZeinaAlHomsi)

Built as an educational project.

### Built With

- [Flutter](https://flutter.dev/) - UI framework
- [Dart](https://dart.dev/) - Programming language
- [Material Design 3](https://m3.material.io/) - Design system

## Repository

[GitHub - JosephDoesLinux/pantry-chef](https://github.com/JosephDoesLinux/pantry-chef)

## License

This project is provided as-is for educational purposes.
