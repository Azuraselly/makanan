import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  SupabaseClient get client => _client; // expose client kalau mau langsung pakai

  /// 🔹 Register user dengan email/password + insert ke profiles
  Future<String> register({
    required String email,
    required String password,
    required String name,
    required String bio,
  }) async {
    try {
      final authResponse = await _client.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );

      final user = authResponse.user;
      if (user == null) {
        throw Exception('Gagal membuat akun: User null');
      }

      await _client.from('profiles').insert({
        'id': user.id,
        'name': name.trim(),
        'bio': bio.trim(),
      });

      return user.id;
    } catch (e) {
      throw Exception('Error register: $e');
    }
  }

  /// Login
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = authResponse.user;
      if (user == null) {
        throw Exception('Gagal login: User null');
      }

      return user.id;
    } catch (e) {
      throw Exception('Error login: $e');
    }
  }

  /// 🔹 Logout
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  /// ================================
  /// Saved Recipes
  /// ================================
  Future<Map<String, dynamic>?> getSavedRecipe(String userId, String recipeId) async {
    return await _client
        .from('saved_recipes')
        .select()
        .eq('user_id', userId)
        .eq('recipe_id', recipeId)
        .maybeSingle();
  }

  Future<void> saveRecipe(String userId, String recipeId) async {
    await _client.from('saved_recipes').insert({
      'user_id': userId,
      'recipe_id': recipeId,
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteSavedRecipe(String userId, String recipeId) async {
    await _client
        .from('saved_recipes')
        .delete()
        .eq('user_id', userId)
        .eq('recipe_id', recipeId);
  }
}
