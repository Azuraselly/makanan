import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/recipe_model.dart';

class DetailRecipePage extends StatelessWidget {
  final RecipeModel recipe;
  final bool isBookmarked;

  const DetailRecipePage({
    Key? key,
    required this.recipe,
    required this.isBookmarked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  recipe.title,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                background: Hero(
                  tag: 'recipe_image_${recipe.id}',
                  child: Image.network(
                    recipe.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey, child: const Icon(Icons.fastfood, size: 100)),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context, !isBookmarked);
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          
                  // Tab menu
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: const TabBar(
                      labelColor: Color(0xFF02480F),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Color(0xFF02480F),
                      tabs: [
                        Tab(text: "Bahan"),
                        Tab(text: "Langkah"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(child: _BahanSection()),
                        SingleChildScrollView(child: _LangkahSection()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BahanSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recipe = (context.findAncestorWidgetOfExactType<DetailRecipePage>())!.recipe;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Bahan-bahan", Icons.local_grocery_store),
          const SizedBox(height: 12),
          ...recipe.ingredients.map((bahan) => AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(bahan, style: GoogleFonts.poppins(fontSize: 15)),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _LangkahSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recipe = (context.findAncestorWidgetOfExactType<DetailRecipePage>())!.recipe;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Langkah Memasak", Icons.menu_book),
          const SizedBox(height: 12),
          ...recipe.steps.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final langkah = entry.value;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF02480F),
                  child: Text(
                    "$index",
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  langkah,
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

Widget _sectionTitle(String title, IconData icon) {
  return Row(
    children: [
      Icon(icon, color: const Color(0xFF48742C), size: 22),
      const SizedBox(width: 8),
      Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
    ],
  );
}
