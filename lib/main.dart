
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:resep/ui/screens/home.dart';
import 'package:resep/ui/screens/login.dart';
import 'package:resep/translations.dart'; 
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

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('id', 'ID'), // bahasa default
      fallbackLocale: const Locale('en', 'US'), // jika bahasa tidak ditemukan
      home: const Login(), 
    );
  }
}
