// File: lib/ui/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resep/ui/components/food_card.dart';
import 'package:resep/ui/components/menu_category_button.dart';
import 'package:resep/ui/models/menu_category.dart';
import 'package:resep/ui/models/recipe_model.dart';
import 'package:resep/ui/screens/bookmark_page.dart';
import 'package:resep/ui/screens/bottom_sheet.dart';
import 'package:resep/ui/screens/profile_page.dart';
import 'package:resep/ui/screens/login.dart';
import 'package:resep/services/service_makanan.dart';
import 'package:resep/services/auth_services.dart'; // Tambahkan import untuk SupabaseService
import 'package:resep/l10n/app_localizations.dart';
import 'package:resep/ui/models/opsi_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:resep/l10n/app_localizations_extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RecipeCategory? selectedCategory = RecipeCategory.all;
  String searchQuery = '';
  final ServiceMakanan _serviceMakanan = ServiceMakanan();

  List<RecipeModel> allRecipes = [];
  bool isLoading = true;

  Future<void> saveLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    setState(() => isLoading = true);
    try {
      final recipes = await _serviceMakanan.fetchRecipes();
      setState(() {
        allRecipes = recipes;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.recipeLoadError(e.toString()),
            ),
          ),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Fungsi untuk menampilkan dialog konfirmasi logout
  Future<bool?> _showLogoutConfirmationDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.logoutConfirmationTitle,
          style: GoogleFonts.ubuntu(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF02480F),
          ),
        ),
        content: Text(
          l10n.logoutConfirmationContent,
          style: GoogleFonts.ubuntu(
            fontSize: 16,
            color: const Color(0xFF02480F),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.cancelButton,
              style: GoogleFonts.ubuntu(
                fontSize: 16,
                color: const Color(0xFF02480F),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.logoutConfirmButton,
              style: GoogleFonts.ubuntu(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<RecipeModel> displayedRecipes =
        selectedCategory == RecipeCategory.all
            ? allRecipes
            : allRecipes
                .where((recipe) => recipe.category == selectedCategory)
                .toList();

    final List<RecipeModel> filteredRecipes = displayedRecipes.where((recipe) {
      return recipe.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadRecipes,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFACDDB5), Color(0xFFF6F6F6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              // Header + tombol tambah
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 5),
                        blurRadius: 5,
                        spreadRadius: 0,
                        color: Color(0xFF00000040),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: l10n.appName,
                              style: GoogleFonts.ubuntu(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF02480F),
                              ),
                            ),
                            const TextSpan(text: '\n'),
                            TextSpan(
                              text: l10n.subtitle,
                              style: GoogleFonts.ubuntu(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF02480F),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (context) => TambahResepBottomSheet(),
                              ).then(
                                (_) => _loadRecipes(),
                              ); // refresh setelah tambah resep
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 30,
                              color: Color(0xFF02480F),
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.menu,
                              size: 30,
                              color: Color(0xFF02480F),
                            ),
                            onSelected: (value) async {
                              switch (value) {
                                case 'profile':
                                  Get.to(() => const ProfilePage())?.then((
                                    result,
                                  ) {
                                    if (result == true) {
                                      _loadRecipes(); // Refresh setelah kembali dari ProfilePage
                                    }
                                  });
                                  break;
                                case 'bookmark':
                                  Get.to(() => const BookmarkPage());
                                  break;
                                case 'exit':
                                  final confirm = await _showLogoutConfirmationDialog(context);
                                  if (confirm == true) {
                                    try {
                                      await SupabaseService().logout(); 
                                      Get.off(() => const Login());
                                    } catch (e) {
                                      Get.snackbar(
                                        l10n.genericErrorTitle,
                                        l10n.genericErrorContent,
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                    }
                                  }
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return OpsiMenu.opsiMenu.map((opsi) {
                                return PopupMenuItem<String>(
                                  value: opsi.value,
                                  child: ListTile(
                                    leading: Icon(opsi.icon),
                                    title: Text(l10n.getMenuTitle(opsi.value)),
                                  ),
                                );
                              }).toList();
                            },
                          ),
                          PopupMenuButton<Locale>(
                            icon: const Icon(
                              Icons.language,
                              size: 30,
                              color: Color(0xFF02480F),
                            ),
                            onSelected: (Locale locale) {
                              Get.updateLocale(locale);
                              saveLocale(locale.languageCode);
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem<Locale>(
                                value: const Locale('en'),
                                child: Row(
                                  children: [
                                    const Text('🇺🇸'),
                                    const SizedBox(width: 8),
                                    Text(l10n.languageEnglish),
                                  ],
                                ),
                              ),
                              PopupMenuItem<Locale>(
                                value: const Locale('id'),
                                child: Row(
                                  children: [
                                    const Text('🇮🇩'),
                                    const SizedBox(width: 8),
                                    Text(l10n.languageIndonesian),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Search Bar
              Center(
                child: SizedBox(
                  width: 377,
                  height: 62,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) => setState(() => searchQuery = value),
                      decoration: InputDecoration(
                        hintText: l10n.searchHint,
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6B6767),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 24,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(
                            color: Color(0xFF58545429),
                            width: 2,
                          ),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Category
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    MenuCategoryButton(
                      category: MenuCategoryModel(
                        title: RecipeCategory.all,
                        image: 'assets/sate.png', // Gambar untuk kategori 'All'
                      ),
                      selectedCategory: selectedCategory,
                      onCategorySelected: (category) =>
                          setState(() => selectedCategory = category),
                    ),
                    const SizedBox(width: 12),
                    ...MenuCategoryModel.category.map(
                      (menuCategory) => Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: MenuCategoryButton(
                          category: menuCategory,
                          selectedCategory: selectedCategory,
                          onCategorySelected: (category) =>
                              setState(() => selectedCategory = category),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Title rekomendasi
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.recommendedRecipeTitle,
                      style: GoogleFonts.ubuntu(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF524D4D),
                        shadows: [
                          Shadow(
                            offset: Offset(0, 5),
                            blurRadius: 5,
                            color: Color(0xFF00000040),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(l10n.seeAllButton),
                    ),
                  ],
                ),
              ),
              // Grid resep
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredRecipes.isEmpty
                        ? Center(child: Text(l10n.noRecipesFound))
                        : GridView.builder(
                            padding: const EdgeInsets.all(8.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: filteredRecipes.length,
                            itemBuilder: (context, index) {
                              return FoodCard(recipe: filteredRecipes[index]);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}