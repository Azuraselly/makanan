import 'package:flutter/material.dart';
import 'package:resep/l10n/app_localizations.dart';

enum RecipeCategory {
  all,
  appetizer,
  mainCourse,
  dessert;

  String getLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      // Fallback to default English labels if localization is unavailable
      switch (this) {
        case RecipeCategory.all:
          return 'All';
        case RecipeCategory.appetizer:
          return 'Appetizer';
        case RecipeCategory.mainCourse:
          return 'Main Course';
        case RecipeCategory.dessert:
          return 'Dessert';
      }
    }
    switch (this) {
      case RecipeCategory.all:
        return l10n.category_all;
      case RecipeCategory.appetizer:
        return l10n.category_appetizer;
      case RecipeCategory.mainCourse:
        return l10n.category_mainCourse;
      case RecipeCategory.dessert:
        return l10n.category_dessert;
    }
  }

  // Convert string category from DB to enum
  static RecipeCategory fromString(String? value) {
    if (value == null || value.trim().isEmpty) {
      return RecipeCategory.all;
    }
    switch (value.toLowerCase()) {
      case 'appetizer':
        return RecipeCategory.appetizer;
      case 'main course':
        return RecipeCategory.mainCourse;
      case 'dessert':
        return RecipeCategory.dessert;

      default:
        return RecipeCategory.all;
    }
  }
}

class RecipeModel {
  final dynamic id; // Can be int or String from database
  final String title;
  final String image;
  final List<String> ingredients;
  final List<String> steps;
  final RecipeCategory category;

  RecipeModel({
    required this.id,
    required this.title,
    required this.image,
    this.ingredients = const [],
    this.steps = const [],
    this.category = RecipeCategory.appetizer,
  });

  // Factory to convert from Supabase
  factory RecipeModel.fromMap(Map<String, dynamic> data) {
    return RecipeModel(
      id: data['id'],
      title: data['nama'] ?? '',
      image: data['gambar_url'] ?? '',
      ingredients: (data['bahan'] ?? '')
          .toString()
          .split('\n')
          .where((e) => e.trim().isNotEmpty)
          .toList(),
      steps: (data['langkah'] ?? '')
          .toString()
          .split('\n')
          .where((e) => e.trim().isNotEmpty)
          .toList(),
      category: RecipeCategory.fromString(data['kategori'] ?? ''),
    );
  }
}
