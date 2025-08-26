import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceBookmark {
  final _supabase = Supabase.instance.client;

  Future<void> addBookmark(String userId, dynamic recipeId) async {
    await _supabase.from('saved_recipes').insert({
      'user_id': userId,
      'recipe_id': recipeId,
    });
  }

  Future<void> removeBookmark(String userId, dynamic recipeId) async {
    await _supabase
        .from('saved_recipes')
        .delete()
        .eq('user_id', userId)
        .eq('recipe_id', recipeId);
  }

  Future<bool> isBookmarked(dynamic recipeId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;

    final result = await _supabase
        .from('saved_recipes')
        .select()
        .eq('user_id', userId)
        .eq('recipe_id', recipeId);

    return result.isNotEmpty;
  }

  /// ✅ Ambil semua resep yang disimpan + join table recipes
  Future<List<Map<String, dynamic>>> getSavedRecipes(String userId) async {
    final result = await _supabase
        .from('saved_recipes')
        .select('makanan(*)') // join dengan tabel makanan
        .eq('user_id', userId);

    // hasil = [{ "makanan": {...}}]
    return result.map<Map<String, dynamic>>((row) {
      return row['makanan'] as Map<String, dynamic>;
    }).toList();
  }
}