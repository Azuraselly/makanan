import 'package:flutter/material.dart';
import 'package:resep/ui/screens/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlkeHFiaXpwamZhc3BoZ3FjZG93Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ5OTE1MjUsImV4cCI6MjA3MDU2NzUyNX0.Gx4ylDKiWCXxFkzne-5EHlwOy9TqGZMb2G_JbBZl6hY',
    url: 'https://idxqbizpjfasphgqcdow.supabase.co',
  );
  runApp(const ResepApp());
}

class ResepApp extends StatelessWidget {
  const ResepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: Login());
  }
}
