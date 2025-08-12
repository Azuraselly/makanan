import 'package:flutter/material.dart';
import 'package:resep/ui/screens/assets.dart' as app_assets;

class MenuCategoryModel {
  UniqueKey? id = UniqueKey();
  String title;
  String image;

  MenuCategoryModel({this.id, this.title = "", this.image = ""});

  static List<MenuCategoryModel> category = [
    MenuCategoryModel(title: "Appetizer", image: app_assets.sate),
    MenuCategoryModel(title: "Main Course", image: app_assets.sate),
    MenuCategoryModel(title: "Dessert", image: app_assets.sate),
    MenuCategoryModel(title: 'Cake', image: app_assets.sate),
  ];
}