import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// ServiceProfile
/// Kelas ini digunakan untuk mengelola data profil pengguna,
/// termasuk ambil data profile, upload avatar, dan kelola resep.
class ServiceProfile {
  final supabase = Supabase.instance.client;

  // ==========================
  // 1. Ambil Data Profil User
  // ==========================
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final profile = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      return profile;
    } catch (e) {
      print('❌ Error getProfile: $e');
      return null;
    }
  }

  // ==========================
  // 2. Upload Avatar ke Storage
  // ==========================
  Future<String> uploadAvatar(XFile file) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('⚠️ Pengguna belum login');

    final userId = user.id;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    final path = '$userId/$fileName';

    try {
      print('🔹 Debug - User ID: $userId');
      print('🔹 Debug - Upload Path: $path');

      // Upload file (beda handling Web vs Mobile)
      if (kIsWeb) {
        final bytes = await file.readAsBytes();
        await supabase.storage.from('avatars').uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            upsert: true,
            metadata: {'user_id': userId}, // Sesuai policy bucket
          ),
        );
      } else {
        await supabase.storage.from('avatars').upload(
          path,
          File(file.path),
          fileOptions: FileOptions(
            upsert: true,
            metadata: {'user_id': userId},
          ),
        );
      }

      // Ambil URL hasil upload
      final publicUrl = supabase.storage.from('avatars').getPublicUrl(path);

      print('✅ Avatar berhasil diupload: $publicUrl');

      // Update URL avatar ke tabel profiles
      await supabase
          .from('profiles')
          .update({'avatar_url': publicUrl})
          .eq('id', userId);

      return publicUrl;
    } catch (e) {
      print('❌ Error uploadAvatar: $e');
      throw Exception('Gagal upload avatar: $e');
    }
  }

  // ==========================
  // 3. Hitung Jumlah Resep User
  // ==========================
  Future<int> countRecipes(String userId) async {
    try {
      final response = await supabase
          .from('makanan')
          .select()
          .eq('user_id', userId);

      return (response as List).length;
    } catch (e) {
      print('❌ Error countRecipes: $e');
      return 0;
    }
  }

  // ==========================
  // 4. Ambil Daftar Resep User
  // ==========================
  Future<List<Map<String, dynamic>>> getUserRecipes(String userId) async {
    try {
      final recipes = await supabase
          .from('makanan')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (recipes as List).cast<Map<String, dynamic>>();
    } catch (e) {
      print('❌ Error getUserRecipes: $e');
      return [];
    }
  }

  // ==========================
  // 5. Hapus Resep Berdasarkan ID
  // ==========================
  Future<void> deleteRecipe(String recipeId) async {
    try {
      await supabase.from('recipes').delete().eq('id', recipeId);
      print('✅ Resep berhasil dihapus: $recipeId');
    } catch (e) {
      print('❌ Error deleteRecipe: $e');
    }
  }
}
