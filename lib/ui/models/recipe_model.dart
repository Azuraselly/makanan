import 'package:flutter/material.dart';
import 'package:resep/ui/screens/assets.dart' as app_asset;

class RecipeModel {
  UniqueKey? id = UniqueKey();
  String title, image;
  List<String> ingredients;
  List<String> steps;
  String category;

  RecipeModel({
    this.id,
    this.title = "",
    this.image = "",
    this.ingredients = const [],
    this.steps = const [],
    this.category = "",
  });

  static List<RecipeModel> recipes = [
    RecipeModel(
      title: "Sate Ayam",
      image: app_asset.sate,
      ingredients: ["1.500 gr dada ayam / paha fillet", "2. Tusuk sate", "3. Seledri", "4.Daun Bawang", "5.Jeruk nipis"],
      steps: [
        "- Campur ayam fillet dengan bahan marinasi. Diamkan selama kuraang lebih 2 jam lebih bagus semalaman di kulkas",
        "- Tusukkan ayam pada tusuk sate selang seling dengan batang seledri. Jika menggunakan jenis bakaran arang, rendam tusuk sate dengan air agar tidak mudah terbakar",
        "- Lumuri sate dengan margarin atau mentega",
        "- Kemudian panggang diatas pan sambil di bolak balk hingga matang",
        "- Angkat dan sajikan selagi hangat dengan daun bawang, daun seledri, dan saus",
        ],
      category: "Appetizer",
    ),
  ];

  static List<String> get categories {
    return recipes.map((e) => e.category).toSet().toList();
  }

  static List<RecipeModel> getByCategory(String category) {
    return recipes.where((recipe) => recipe.category == category).toList();
  }
}