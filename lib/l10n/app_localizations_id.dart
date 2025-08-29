// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'L’Atelier du Chef';

  @override
  String get subtitle => 'BENGKEL KOKI';

  @override
  String get description =>
      'Siap memperkaya koleksi masakan rumah Anda? Jelajahi semua resep yang kami tawarkan dan temukan ide baru untuk setiap hidangan!';

  @override
  String get createAccountButton => 'Buat Akun';

  @override
  String get loginButton => 'Masuk';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'contoh@domain.com';

  @override
  String get emailEmptyError => 'Email tidak boleh kosong';

  @override
  String get emailInvalidError => 'Format email tidak valid';

  @override
  String get nameLabel => 'Nama';

  @override
  String get nameHint => 'Nama lengkap';

  @override
  String get nameEmptyError => 'Nama tidak boleh kosong';

  @override
  String get bioLabel => 'Bio';

  @override
  String get bioHint => 'Deskripsi singkat tentang diri Anda';

  @override
  String get bioEmptyError => 'Bio tidak boleh kosong';

  @override
  String get passwordLabel => 'Kata Sandi';

  @override
  String get passwordHint => 'Masukkan kata sandi Anda';

  @override
  String get passwordEmptyError => 'Kata sandi tidak boleh kosong';

  @override
  String get passwordMinLengthError => 'Kata sandi harus minimal 6 karakter';

  @override
  String get confirmPasswordLabel => 'Konfirmasi Kata Sandi';

  @override
  String get confirmPasswordHint => 'Masukkan kata sandi lagi';

  @override
  String get confirmPasswordEmptyError =>
      'Konfirmasi kata sandi tidak boleh kosong';

  @override
  String get confirmPasswordMismatchError => 'Kata sandi tidak cocok';

  @override
  String get loginFailedTitle => 'Gagal Masuk';

  @override
  String get loginFailedContent => 'Akun tidak ada atau kata sandi salah.';

  @override
  String get registerFailedTitle => 'Pendaftaran Gagal';

  @override
  String get registerFailedContent =>
      'Akun sudah ada. Gunakan email lain atau masuk.';

  @override
  String get genericErrorTitle => 'Terjadi Kesalahan';

  @override
  String get genericErrorContent => 'Terjadi kesalahan. Silakan coba lagi.';

  @override
  String get switchAuthTextLogin => 'Belum punya akun? ';

  @override
  String get switchAuthTextRegister => 'Sudah punya akun? ';

  @override
  String get switchAuthButton => 'Ganti';

  @override
  String get ok => 'OK';

  @override
  String get languageEnglish => 'Inggris';

  @override
  String get languageIndonesian => 'Indonesia';

  @override
  String get profileTitle => 'Profil';

  @override
  String get editProfileButton => 'Edit Profil';

  @override
  String get postsLabel => 'Postingan';

  @override
  String get emptyRecipeMessage => 'Belum ada resep yang kamu tambahkan';

  @override
  String get recipeSectionTitle => 'Resep Saya';

  @override
  String get saveButton => 'Simpan';

  @override
  String get profileNameLabel => 'Nama';

  @override
  String get profileNameEmptyError => 'Nama wajib diisi';

  @override
  String get profileBioLabel => 'Bio';

  @override
  String get defaultUserName => 'Pengguna';

  @override
  String get defaultBio => 'Tambahkan bio agar lebih menarik!';

  @override
  String get logoutConfirmationTitle => 'Konfirmasi Keluar';

  @override
  String get logoutConfirmationContent => 'Apakah Anda yakin ingin keluar?';

  @override
  String get logoutConfirmButton => 'Keluar';

  @override
  String get cancelButton => 'Batal';

  @override
  String profileLoadError(Object error) {
    return 'Gagal memuat profil: $error';
  }

  @override
  String get profileUpdateSuccess => 'Profil berhasil diperbarui';

  @override
  String profileUpdateError(Object error) {
    return 'Gagal memperbarui profil: $error';
  }

  @override
  String get userNotLoggedInError => 'Pengguna belum login';

  @override
  String get searchHint => 'Cari Resep...';

  @override
  String get recommendedRecipeTitle => 'Resep Rekomendasi';

  @override
  String get noRecipesFound => 'Tidak ada resep ditemukan';

  @override
  String get category_all => 'Semua';

  @override
  String get category_appetizer => 'Hidangan Pembuka';

  @override
  String get category_mainCourse => 'Hidangan Utama';

  @override
  String get category_dessert => 'Hidangan Penutup';

  @override
  String get category_cake => 'Kue';

  @override
  String get deleteButton => 'Hapus';

  @override
  String get deleteDialogTitle => 'Hapus Resep?';

  @override
  String get deleteDialogMessage =>
      'Apakah kamu yakin ingin menghapus resep ini? Aksi ini tidak bisa dibatalkan.';

  @override
  String get confirmDeleteButton => 'Hapus';

  @override
  String get deleteSuccessMessage => 'Resep berhasil dihapus';

  @override
  String get deleteErrorMessage => 'Gagal menghapus resep';

  @override
  String recipeLoadError(Object error) {
    return 'Gagal memuat resep: $error';
  }

  @override
  String get menuProfile => 'Profil';

  @override
  String get menuLanguage => 'Bahasa';

  @override
  String get menuBookmark => 'Bookmark';

  @override
  String get menuExit => 'Keluar';

  @override
  String get ingredientsTab => 'Bahan';

  @override
  String get stepsTab => 'Langkah';

  @override
  String get ingredientsTitle => 'Bahan-bahan';

  @override
  String get stepsTitle => 'Langkah Memasak';

  @override
  String recipeImageLabel(Object title) {
    return 'Gambar dari $title';
  }
}
