// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';

// class AppTranslation extends Translations {
//   static Map<String, Map<String, String>> _translations = {};

//   static Future<void> load() async {
//     final enData = await rootBundle.loadString('assets/translations/en.json');
//     final idData = await rootBundle.loadString('assets/translations/id.json');

//     final enJson = json.decode(enData);
//     final idJson = json.decode(idData);

//     _translations['en'] = _flattenMap(enJson);
//     _translations['id'] = _flattenMap(idJson);
//   }

//   // helper untuk ubah nested json jadi flat
//   static Map<String, String> _flattenMap(Map<String, dynamic> map,
//       [String prefix = '']) {
//     final result = <String, String>{};

//     map.forEach((key, value) {
//       final newKey = prefix.isEmpty ? key : "$prefix.$key";

//       if (value is Map) {
//         result.addAll(_flattenMap(Map<String, dynamic>.from(value), newKey));
//       } else {
//         result[newKey] = value.toString();
//       }
//     });

//     return result;
//   }

//   @override
//   Map<String, Map<String, String>> get keys => _translations;
// }
