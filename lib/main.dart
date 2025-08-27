import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resep/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:resep/ui/screens/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlkeHFiaXpwamZhc3BoZ3FjZG93Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ5OTE1MjUsImV4cCI6MjA3MDU2NzUyNX0.Gx4ylDKiWCXxFkzne-5EHlwOy9TqGZMb2G_JbBZl6hY',
    url: 'https://idxqbizpjfasphgqcdow.supabase.co',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Locale> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'id';
    return Locale(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Locale>(
      future: loadLocale(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('id'),
            ],
            locale: Get.locale ?? snapshot.data,
            home: const Login(),
          );
        }
        return const Center(child: CircularProgressIndicator(color: Colors.red,));
      },
    );
  }
}