import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/service_makanan.dart';

class TambahResepBottomSheet extends StatefulWidget {
  const TambahResepBottomSheet({super.key});

  @override
  State<TambahResepBottomSheet> createState() => _TambahResepBottomSheetState();
}

class _TambahResepBottomSheetState extends State<TambahResepBottomSheet> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController bahanController = TextEditingController();
  final TextEditingController langkahController = TextEditingController();

  final List<String> kategoriList = ['Appetizer', 'Main Course', 'Dessert'];
  String? selectedKategori;
  XFile? selectedImage;

  final picker = ImagePicker();
  final serviceMakanan = ServiceMakanan();

  bool isLoading = false;

  Future<void> pilihGambar() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = picked;
        print('Gambar dipilih: ${picked.path}');
      });
    } else {
      print('Tidak ada gambar yang dipilih');
    }
  }

  Future<void> simpanResep() async {
    print('Tombol Simpan diklik');
    if (selectedKategori == null ||
        namaController.text.isEmpty ||
        bahanController.text.isEmpty ||
        langkahController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      print('Mengunggah data ke ServiceMakanan...');
      await serviceMakanan.tambahMakanan(
        kategori: selectedKategori!,
        nama: namaController.text,
        bahan: bahanController.text,
        langkah: langkahController.text,
        gambarFile: selectedImage,
      );

      print('Resep berhasil disimpan');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Makanan berhasil disimpan")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error menyimpan resep: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan resep: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
        print('Proses selesai, isLoading: $isLoading');
      }
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    bahanController.dispose();
    langkahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE4EFDD), Color(0xFFB8D8A0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔙 Tombol Back + Judul
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xFF02480F)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Resep Baru",
                      style: GoogleFonts.ubuntu(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF02480F),
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 6,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // biar teks tetap center
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: kIsWeb
                                ? FutureBuilder<Uint8List>(
                                    future: selectedImage!.readAsBytes(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Image.memory(
                                          snapshot.data!,
                                          fit: BoxFit.cover,
                                        );
                                      }
                                      return Center(
                                          child: CircularProgressIndicator());
                                    },
                                  )
                                : Image.file(
                                    File(selectedImage!.path),
                                    fit: BoxFit.cover,
                                  ),
                          )
                        : Icon(Icons.restaurant_menu,
                            size: 60, color: Colors.grey[400]),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: GestureDetector(
                      onTap: pilihGambar,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: Color(0xFF02480F),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.add_a_photo,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Kategori",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF02480F),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Pilih Kategori",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF48742C),
                  ),
                ),
                value: selectedKategori,
                onChanged: (value) {
                  setState(() {
                    selectedKategori = value;
                    print('Kategori dipilih: $value');
                  });
                },
                items: kategoriList.map((String kategori) {
                  return DropdownMenuItem<String>(
                    value: kategori,
                    child: Text(
                      kategori,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF02480F),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(namaController, "Nama Resep", maxLines: 1),
            const SizedBox(height: 16),
            _buildTextField(bahanController, "Bahan-bahan", maxLines: null),
            const SizedBox(height: 16),
            _buildTextField(langkahController, "Langkah-langkah", maxLines: null),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF02480F),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    onPressed: isLoading ? null : simpanResep,
                    child: isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Simpan Resep",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int? maxLines}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF02480F),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType:
                maxLines == null ? TextInputType.multiline : TextInputType.text,
            decoration: InputDecoration(
              hintText: "Masukkan $label",
              hintStyle: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF48742C).withOpacity(0.6),
              ),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              print('$label diubah: $value');
            },
          ),
        ),
      ],
    );
  }
}
