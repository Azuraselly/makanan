// File: lib/services/service_profile.dart

import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../ui/models/recipe_model.dart';

class ServiceProfile {
  final supabase = Supabase.instance.client;

  // Ambil profil pengguna
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return response;
    } catch (e) {
      throw Exception('Gagal memuat profil: $e');
    }
  }

  // Hitung jumlah resep pengguna
  Future<int> countRecipes(String userId) async {
    try {
      final response = await supabase
          .from('makanan')
          .select('id')
          .eq('user_id', userId);
      return (response as List).length;
    } catch (e) {
      throw Exception('Gagal menghitung resep: $e');
    }
  }

  // Ambil resep pengguna
  Future<List<Map<String, dynamic>>> getUserRecipes(String userId) async {
    try {
      final response = await supabase
          .from('makanan')
          .select()
          .eq('user_id', userId);
      return response as List<Map<String, dynamic>>;
    } catch (e) {
      throw Exception('Gagal memuat resep: $e');
    }
  }

  // Upload avatar
  Future<String> uploadAvatar(XFile avatarFile) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User belum login');

    final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final path = '$userId/$fileName';
    try {
      if (kIsWeb) {
        final bytes = await avatarFile.readAsBytes();
        await supabase.storage.from('avatars').uploadBinary(path, bytes);
      } else {
        await supabase.storage.from('avatars').upload(path, File(avatarFile.path));
      }
      return supabase.storage.from('avatars').getPublicUrl(path);
    } catch (e) {
      throw Exception('Gagal mengunggah avatar: $e');
    }
  }

  // Hapus resep
  Future<void> deleteRecipe(String recipeId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User belum login');

    try {
      // Ambil data resep untuk mendapatkan URL gambar (jika ada)
      final response = await supabase
          .from('makanan')
          .select('gambar_url')
          .eq('id', recipeId)
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        throw Exception('Resep tidak ditemukan atau Anda tidak memiliki akses');
      }

      // Hapus gambar dari storage jika ada
      if (response['gambar_url'] != null) {
        final imagePath = response['gambar_url'].split('/').last;
        await supabase.storage.from('makanan').remove(['$userId/$imagePath']);
      }

      // Hapus resep dari tabel
      await supabase.from('makanan').delete().eq('id', recipeId).eq('user_id', userId);
    } on PostgrestException catch (e) {
      throw Exception('Gagal menghapus resep: ${e.message}');
    } catch (e) {
      throw Exception('Gagal menghapus resep: $e');
    }
  }
}