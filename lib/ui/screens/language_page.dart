import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LanguagePage extends StatelessWidget {
  final languages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'Bahasa Indonesia', 'code': 'id'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Settings'.tr),
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 10),
            Icon(Icons.language, size: 80, color: Colors.deepOrangeAccent),
            SizedBox(height: 20),
            Text(
              'Select your preferred language'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
