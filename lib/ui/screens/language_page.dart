import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resep/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = Get.locale?.languageCode ?? 'id';
  }

  Future<void> saveLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.languageEnglish), // Menggunakan terjemahan
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RadioListTile<String>(
            value: "id",
            groupValue: _selectedLanguage,
            title: Text(l10n.languageIndonesian), // Menggunakan terjemahan
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value;
              });
              Get.updateLocale(const Locale('id'));
              saveLocale(value!);
            },
          ),
          RadioListTile<String>(
            value: "en",
            groupValue: _selectedLanguage,
            title: Text(l10n.languageEnglish), // Belum diterjemahkan, bisa diganti
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value;
              });
              Get.updateLocale(const Locale('en'));
              saveLocale(value!);
            },
          ),
        ],
      ),
    );
  }
}