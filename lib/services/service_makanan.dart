import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:resep/ui/models/recipe_model.dart';
import 'package:image_picker/image_picker.dart';

class ServiceMakanan {
  final supabase = Supabase.instance.client;

  /// Tambah makanan baru ke Supabase dengan upload gambar
  Future<void> tambahMakanan({
    required String kategori,
    required String nama,
    required String bahan,
    required String langkah,
    XFile? gambarFile,
  }) async {
    print('Memulai tambahMakanan: kategori=$kategori, nama=$nama');
    if (kategori.isEmpty || nama.isEmpty || bahan.isEmpty || langkah.isEmpty) {
      print('Validasi gagal: Semua field wajib diisi');
      throw Exception('Semua field wajib diisi');
    }
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      print('Error: User belum login');
      throw Exception('User belum login');
    }

    String? gambarUrl;
    if (gambarFile != null) {
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = '$userId/$fileName';
      print('Mengunggah gambar ke: $path');
      try {
        if (kIsWeb) {
          final bytes = await gambarFile.readAsBytes();
          print('Mengunggah sebagai binary untuk web');
          await supabase.storage.from('makanan').uploadBinary(path, bytes);
        } else {
          print('Mengunggah sebagai file untuk mobile');
          await supabase.storage.from('makanan').upload(path, File(gambarFile.path));
        }
        gambarUrl = supabase.storage.from('makanan').getPublicUrl(path);
        print('Gambar diunggah: $gambarUrl');
      } on StorageException catch (e) {
        print('StorageException: ${e.message}');
        throw Exception('Gagal mengunggah gambar: ${e.message}');
      }
    } else {
      print('Tidak ada gambar yang diunggah');
    }

    print('Menyimpan data ke tabel makanan...');
    try {
      await supabase.from('makanan').insert({
        'user_id': userId,
        'kategori': kategori,
        'nama': nama,
        'bahan': bahan,
        'langkah': langkah,
        'gambar_url': gambarUrl,
      });
      print('Data berhasil disimpan ke tabel makanan');
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw Exception('Gagal menyimpan data: ${e.message}');
    }
  }

  /// Ambil semua makanan dari Supabase dengan pagination
  Future<List<RecipeModel>> fetchRecipes({int page = 0, int limit = 20}) async {
    try {
      final response = await supabase
          .from('makanan')
          .select()
          .range(page * limit, (page + 1) * limit - 1);
      return (response as List)
          .map((data) => RecipeModel.fromMap(data))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Gagal mengambil data makanan: ${e.message}');
    } catch (e) {
      throw Exception('Gagal mengambil data makanan: $e');
    }
  }

  /// Ambil daftar kategori unik
  Future<List<String>> fetchCategories() async {
    try {
      final response = await supabase
          .from('makanan')
          .select('kategori')
          .order('kategori', ascending: true);

      final kategoriUnik = <String>{};
      for (var item in response as List) {
        if (item['kategori'] != null) {
          kategoriUnik.add(item['kategori'] as String);
        }
      }
      return kategoriUnik.toList();
    } on PostgrestException catch (e) {
      throw Exception('Gagal mengambil kategori: ${e.message}');
    } catch (e) {
      throw Exception('Gagal mengambil kategori: $e');
    }
  }

  /// Update makanan berdasarkan ID
  Future<void> updateMakanan({
    required String id, // Ubah ke String
    String? kategori,
    String? nama,
    String? bahan,
    String? langkah,
    XFile? gambarFile,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User belum login');

    String? gambarUrl;
    if (gambarFile != null) {
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = '$userId/$fileName';
      try {
        if (kIsWeb) {
          final bytes = await gambarFile.readAsBytes();
          await supabase.storage.from('makanan').uploadBinary(path, bytes);
        } else {
          await supabase.storage.from('makanan').upload(path, File(gambarFile.path));
        }
        gambarUrl = supabase.storage.from('makanan').getPublicUrl(path);
      } on StorageException catch (e) {
        throw Exception('Gagal mengunggah gambar: ${e.message}');
      }
    }

    final updates = {
      if (kategori != null && kategori.isNotEmpty) 'kategori': kategori,
      if (nama != null && nama.isNotEmpty) 'nama': nama,
      if (bahan != null && bahan.isNotEmpty) 'bahan': bahan,
      if (langkah != null && langkah.isNotEmpty) 'langkah': langkah,
      if (gambarUrl != null) 'gambar_url': gambarUrl,
    };

    if (updates.isEmpty) throw Exception('Tidak ada data untuk diperbarui');

    try {
      await supabase.from('makanan').update(updates).eq('id', id).eq('user_id', userId);
    } on PostgrestException catch (e) {
      throw Exception('Gagal memperbarui resep: ${e.message}');
    } catch (e) {
      throw Exception('Gagal memperbarui resep: $e');
    }
  }

  /// Hapus makanan berdasarkan ID
  Future<void> deleteMakanan(String id) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User belum login');

    try {
      // Ambil data resep untuk mendapatkan URL gambar (jika ada)
      final response = await supabase
          .from('makanan')
          .select('gambar_url')
          .eq('id', id)
          .eq('user_id', userId)
          .maybeSingle(); // Gunakan maybeSingle untuk menangani kasus tidak ditemukan

      if (response == null) {
        throw Exception('Resep tidak ditemukan atau Anda tidak memiliki akses');
      }

      // Hapus gambar dari storage jika ada
      if (response['gambar_url'] != null) {
        final imagePath = response['gambar_url'].split('/').last;
        await supabase.storage.from('makanan').remove(['$userId/$imagePath']);
      }

      // Hapus resep dari tabel
      await supabase.from('makanan').delete().eq('id', id).eq('user_id', userId);
    } on PostgrestException catch (e) {
      throw Exception('Gagal menghapus resep: ${e.message}');
    } catch (e) {
      throw Exception('Gagal menghapus resep: $e');
    }
  }
}