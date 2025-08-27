import 'recipe_model.dart';

class MenuCategoryModel {
  final RecipeCategory title;
  final String image;

  MenuCategoryModel({
    required this.title,
    required this.image,
  });

  // Daftar statis sebagai referensi untuk gambar kategori
  static final List<MenuCategoryModel> category = [
    MenuCategoryModel(title: RecipeCategory.appetizer, image: 'assets/salad.png'),
    MenuCategoryModel(title: RecipeCategory.mainCourse, image: 'assets/ayam_bakar.png'),
    MenuCategoryModel(title: RecipeCategory.dessert, image: 'assets/pancake.png'),
   
  ];

  // Metode untuk mendapatkan gambar berdasarkan kategori
  static String getImageForCategory(RecipeCategory recipeCategory) {
    final match = category.firstWhere(
      (item) => item.title == recipeCategory,
      orElse: () => MenuCategoryModel(title: recipeCategory, image: 'assets/default.png'),
    );
    return match.image;
  }
}