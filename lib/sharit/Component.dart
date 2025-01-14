import 'package:flutter/material.dart';

import 'dart:convert'; // لتحويل البيانات من JSON
import 'package:flutter/services.dart'; // للوصول للـ assets

Widget whiteLine({double width = 10, double height = 1}) => Container(
      width: width, // يمكنك تحديد العرض بناءً على حاجتك
      height: height, // عرض الخط
      color: Colors.white.withValues(alpha: .7), // لون الخط الأبيض
    );

Future<void> loadJsonData() async {
  // قراءة محتويات ملف JSON
  final String response = await rootBundle.loadString('players_data.json');

  // تحويل النص لبيانات JSON
  final data = json.decode(response);

  // استخدام البيانات (على سبيل المثال طباعة البيانات)
  print(data);
}
