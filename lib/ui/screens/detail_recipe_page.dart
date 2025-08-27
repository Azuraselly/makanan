import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/recipe_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:resep/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/service_bookmark.dart';

class DetailRecipePage extends StatefulWidget {
  final RecipeModel recipe;
  final bool isBookmarked;

  const DetailRecipePage({
    Key? key,
    required this.recipe,
    required this.isBookmarked,
  }) : super(key: key);

  @override
  State<DetailRecipePage> createState() => _DetailRecipePageState();
}

class _DetailRecipePageState extends State<DetailRecipePage> {
  late bool _isBookmarked;
  final ServiceBookmark _bookmarkService = ServiceBookmark();

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.isBookmarked;
    _checkBookmarkStatus();
  }

  Future<void> _checkBookmarkStatus() async {
    final isSaved = await _bookmarkService.isBookmarked(widget.recipe.id);
    if (!mounted) return;
    setState(() {
      _isBookmarked = isSaved;
    });
  }

  Future<void> _toggleBookmark() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login untuk menyimpan resep!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    try {
      if (_isBookmarked) {
        await _bookmarkService.addBookmark(userId, widget.recipe.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Resep disimpan ke bookmark!'),
            backgroundColor: Color(0xFF48742C),
          ),
        );
      } else {
        await _bookmarkService.removeBookmark(userId, widget.recipe.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Resep dihapus dari bookmark!'),
            backgroundColor: Color(0xFF48742C),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isBookmarked = !_isBookmarked;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> saveLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleBookmark,
          backgroundColor: const Color(0xFF02480F),
          child: Icon(
            _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: Colors.white,
            size: 28,
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: const Color(0xFF02480F),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context, _isBookmarked),
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 50),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.recipe.title,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 4,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'recipe_image_${widget.recipe.id}',
                      child: Image.network(
                        widget.recipe.image,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.fastfood,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tab menu
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey[600],
                      indicator: BoxDecoration(
                        color: const Color(0xFF02480F),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      indicatorPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        Tab(text: l10n.ingredientsTab),
                        Tab(text: l10n.stepsTab),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(child: _BahanSection(recipe: widget.recipe)),
                        SingleChildScrollView(child: _LangkahSection(recipe: widget.recipe)),
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
  final RecipeModel recipe;
  const _BahanSection({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(l10n.ingredientsTitle, Icons.local_grocery_store),
          const SizedBox(height: 12),
          ...recipe.ingredients.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final bahan = entry.value;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF02480F),
                    radius: 18,
                    child: Text(
                      "$index",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  title: Text(
                    bahan,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _LangkahSection extends StatelessWidget {
  final RecipeModel recipe;
  const _LangkahSection({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(l10n.stepsTitle, Icons.menu_book),
          const SizedBox(height: 12),
          ...recipe.steps.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final langkah = entry.value;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF02480F),
                    radius: 18,
                    child: Text(
                      "$index",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  title: Text(
                    langkah,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
      Icon(icon, color: const Color(0xFF02480F), size: 24),
      const SizedBox(width: 8),
      Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF02480F),
        ),
      ),
    ],
  );
}
