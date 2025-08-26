import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceProfile {
  final supabase = Supabase.instance.client;

  /// Ambil data profile dari tabel `profiles`
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final profile = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return profile;
    } catch (e) {
      print('Error getProfile: $e');
      return null;
    }
  }

  /// Upload avatar ke bucket `avatars`
  Future<String> uploadAvatar(XFile file) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('Pengguna belum login');

    final userId = user.id;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    final path = '$userId/$fileName';

    try {
      print('Debug - User ID: $userId');
      print('Debug - Upload Path: $path');

      // Upload file (beda handling untuk Web dan Mobile)
      if (kIsWeb) {
        final bytes = await file.readAsBytes();
        await supabase.storage.from('avatars').uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            upsert: true,
            metadata: {'user_id': userId}, // sesuai policy
          ),
        );
      } else {
        await supabase.storage.from('avatars').upload(
          path,
          File(file.path),
          fileOptions: FileOptions(
            upsert: true,
            metadata: {'user_id': userId}, // sesuai policy
          ),
        );
      }

      // Jika bucket PUBLIC → langsung ambil public URL
      final publicUrl = supabase.storage.from('avatars').getPublicUrl(path);

      // Jika bucket PRIVATE → gunakan signed URL (contoh: berlaku 1 jam)
      // final signedUrl = await supabase.storage.from('avatars').createSignedUrl(path, 3600);

      print('Debug - Avatar URL: $publicUrl');

      // Update ke tabel profiles
      await supabase
          .from('profiles')
          .update({'avatar_url': publicUrl})
          .eq('id', userId);

      return publicUrl;
    } catch (e) {
      print('Debug - Error during upload: $e');
      throw Exception('Gagal upload avatar: $e');
    }
  }

  /// Hitung jumlah resep user
  Future<int> countRecipes(String userId) async {
    try {
      final response = await supabase
          .from('makanan')
          .select()
          .eq('user_id', userId);
      return (response as List).length;
    } catch (e) {
      print('Error countRecipes: $e');
      return 0;
    }
  }

  /// Ambil resep milik user
  Future<List<Map<String, dynamic>>> getUserRecipes(String userId) async {
    try {
      final recipes = await supabase
          .from('makanan')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return (recipes as List).cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error getUserRecipes: $e');
      return [];
    }
  }
}
