import 'package:flutter/material.dart';
import 'package:resep/ui/components/food_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resep/ui/components/menu_category_button.dart';
import 'package:resep/ui/models/menu_category.dart';
import 'package:resep/ui/models/recipe_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final List<RecipeModel> displayedRecipes = selectedCategory == 'All'
        ? RecipeModel.recipes
        : RecipeModel.getByCategory(selectedCategory);

    return Scaffold(
      body: Container(
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
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, 
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'L’Atelier du Chef\n',
                          style: GoogleFonts.ubuntu(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF02480F),
                          ),
                        ),
                        TextSpan(
                          text: 'BENGKEL SI KOKI',
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
                    children: const [
                      Icon(Icons.add, size: 30, color: Color(0xFF02480F)),
                      SizedBox(width: 16),
                      Icon(Icons.more_vert, size: 30, color: Color(0xFF02480F)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),

            Center(
            child: SizedBox(
              width: 367,
              height: 52,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari Resep...',
                    hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: Color(0xFF6B6767)),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 24,),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            ),

            SizedBox(height: 20, width: 15,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Wrap(
                children: [
                  MenuCategoryButton(
                    category: MenuCategoryModel(
                      title: 'All',
                      image: 'sate.png',
                    ),
                    onCategorySelected: (category) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                  SizedBox(width: 12),
                  ...MenuCategoryModel.category.map(
                    (category) => MenuCategoryButton(
                      category: category,
                      onCategorySelected: (category) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommended Recipe',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text('See All')),
                ],
              ),
            ),
            Expanded(
              child: displayedRecipes.isEmpty
                  ? const Center(child: Text('No recipes available'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: displayedRecipes.length,
                      itemBuilder: (context, index) {
                        return FoodCard(recipe: displayedRecipes[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
