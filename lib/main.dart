import 'package:flutter/material.dart';
import 'package:resep/ui/screens/login.dart';

void main() {
  runApp(const ResepApp());
}

class ResepApp extends StatelessWidget {
  const ResepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: login());
  }
}
