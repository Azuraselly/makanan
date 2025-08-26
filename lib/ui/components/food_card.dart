import 'package:flutter/material.dart';
import 'package:resep/ui/models/recipe_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resep/ui/screens/detail_recipe_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; 
import '../../services/service_bookmark.dart';

class FoodCard extends StatefulWidget {
  const FoodCard({Key? key, required this.recipe});

  final RecipeModel recipe;

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool _isBookmarked = false;

  // tambahkan instance ServiceBookmark
  final ServiceBookmark _bookmarkService = ServiceBookmark();

  @override
  void initState() {
    super.initState();
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
        SnackBar(content: Text('Silakan login untuk menyimpan resep!'), backgroundColor: Colors.red),
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
          SnackBar(content: Text('Resep disimpan ke bookmark!'), backgroundColor: Color(0xFF48742C)),
        );
      } else {
        await _bookmarkService.removeBookmark(userId, widget.recipe.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resep dihapus dari bookmark!'), backgroundColor: Color(0xFF48742C)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isBookmarked = !_isBookmarked;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailRecipePage(
                recipe: widget.recipe,
                isBookmarked: _isBookmarked, // kirim status bookmark
              ),
            ),
          ).then((value) {
            // kalau kembali dari detail, update status bookmark di card
            if (value != null && value is bool) {
              setState(() {
                _isBookmarked = value;
              });
            }
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 180,
          height: 192,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    widget.recipe.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 80,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        widget.recipe.title,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis, // biar gak overflow
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: _toggleBookmark,
                      icon: Icon(
                        _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        size: 30,
                        color: Colors.brown, // biar lebih kelihatan
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}