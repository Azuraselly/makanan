import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/service_bookmark.dart';
import '../models/recipe_model.dart';
import 'package:resep/ui/screens/detail_recipe_page.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  late Future<List<Map<String, dynamic>>> _bookmarkedRecipes;

  @override
  void initState() {
    super.initState();
    _refreshBookmarks();
  }

  Future<void> _refreshBookmarks() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      _bookmarkedRecipes = ServiceBookmark().getSavedRecipes(user.id);
    } else {
      _bookmarkedRecipes = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Bookmark",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bookmarkedRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            );
          }

          final recipes = snapshot.data ?? [];
          if (recipes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bookmark_border,
                      size: 80, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    "Belum ada resep tersimpan",
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshBookmarks,
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 kolom biar kayak feed Instagram
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];

                final recipeModel = RecipeModel(
                  id: recipe['id'].toString(),
                  title: recipe['nama'] ?? "Tanpa Judul",
                  image: recipe['gambar_url'] ?? "",
                  category: RecipeCategory.values.firstWhere(
                    (e) => e.name == (recipe['kategori'] ?? "all"),
                    orElse: () => RecipeCategory.all,
                  ),
                  ingredients: (recipe['bahan'] as String?)?.split('\n') ?? [],
                  steps: (recipe['langkah'] as String?)?.split('\n') ?? [],
                );

                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailRecipePage(
                          recipe: recipeModel,
                          isBookmarked: true,
                        ),
                      ),
                    );

                    if (result != null && result is bool && !result) {
                      setState(() {
                        _refreshBookmarks();
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Gambar
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: recipeModel.image.isNotEmpty
                              ? Image.network(
                                  recipeModel.image,
                                  height: 140,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                          height: 140,
                                          color: Colors.grey[200],
                                          child: const Icon(Icons.fastfood,
                                              size: 40,
                                              color: Colors.grey)),
                                )
                              : Container(
                                  height: 140,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.fastfood,
                                      size: 40, color: Colors.grey),
                                ),
                        ),

                        /// Judul & kategori
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipeModel.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  recipeModel.category.label,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green[700]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
