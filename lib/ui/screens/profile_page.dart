import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resep/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/service_profile.dart';
import '../models/recipe_model.dart';
import 'package:resep/ui/components/food_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profileService = ServiceProfile();

  Map<String, dynamic>? profile;
  int recipeCount = 0;
  List<RecipeModel> userRecipes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (mounted) setState(() => loading = false);
      return;
    }

    try {
      final prof = await profileService.getProfile(user.id);
      final count = await profileService.countRecipes(user.id);
      final recipes = await profileService.getUserRecipes(user.id);

      if (mounted) {
        setState(() {
          profile = prof;
          recipeCount = count;
          userRecipes = recipes.map((e) => RecipeModel.fromMap(e)).toList();
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.profileLoadError(e.toString())),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final name = profile?['name'] ?? l10n.defaultUserName;
    final bio = profile?['bio'] ?? l10n.defaultBio;
    final avatarUrl = profile?['avatar_url'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.profileTitle,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              /// Avatar + Nama + Bio
              Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: avatarUrl != null
                        ? NetworkImage(avatarUrl)
                        : const AssetImage("assets/sate.png") as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bio,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  /// hanya Postingan (tanpa followers/following)
                  _statCard("$recipeCount", l10n.postsLabel, Icons.restaurant),
                  const SizedBox(height: 16),
                  /// Tombol Edit Profil
                  ElevatedButton(
                    onPressed: () async {
                      final updated = await showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: EditProfileModal(
                            name: name,
                            bio: bio,
                            avatarUrl: avatarUrl,
                          ),
                        ),
                      );
                      if (updated == true) _loadProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF02480F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 40,
                      ),
                    ),
                    child: Text(
                      l10n.editProfileButton,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              /// Grid Resep Saya
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      l10n.recipeSectionTitle,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              userRecipes.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          const Icon(Icons.no_food, size: 70, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(
                            l10n.emptyRecipeMessage,
                            style: GoogleFonts.poppins(
                              color: Colors.grey[700],
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        childAspectRatio: 1,
                      ),
                      itemCount: userRecipes.length,
                      itemBuilder: (context, index) {
                        return FoodCard(recipe: userRecipes[index]);
                      },
                    ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String count, String label, IconData icon) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class EditProfileModal extends StatefulWidget {
  final String name;
  final String bio;
  final String? avatarUrl;

  const EditProfileModal({
    Key? key,
    required this.name,
    required this.bio,
    this.avatarUrl,
  }) : super(key: key);

  @override
  State<EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<EditProfileModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final profileService = ServiceProfile();
  final picker = ImagePicker();

  String? avatarUrl;
  XFile? newAvatar;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _bioController.text = widget.bio;
    avatarUrl = widget.avatarUrl;
  }

  Future<void> _pickAvatar() async {
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null && mounted) {
      setState(() {
        newAvatar = file;
      });
    }
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;

    setState(() => loading = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception(l10n.userNotLoggedInError);

      if (newAvatar != null) {
        avatarUrl = await profileService.uploadAvatar(newAvatar!);
      }

      await Supabase.instance.client.from('profiles').update({
        'name': _nameController.text.trim(),
        'bio': _bioController.text.trim(),
      }).eq('id', user.id);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileUpdateSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileUpdateError(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickAvatar,
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: newAvatar != null
                      ? kIsWeb
                          ? NetworkImage(newAvatar!.path)
                          : FileImage(File(newAvatar!.path)) as ImageProvider
                      : avatarUrl != null
                          ? NetworkImage(avatarUrl!)
                          : const AssetImage("assets/sate.png") as ImageProvider,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 16,
                      child: const Icon(Icons.camera_alt, size: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.profileNameLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? l10n.profileNameEmptyError : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bioController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: l10n.profileBioLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF02480F),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          l10n.saveButton,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}