import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../models/PalyerModel.dart';
import 'package:http/http.dart' as http;


var logger = Logger();

Future<List<PlayerModel>> fetchPlayerData() async {
  try {
    // طلب البيانات من الرابط
    final response =
        await http.get(Uri.parse('https://guesstheplayer.site/player22.json'));

    if (response.statusCode == 200) {
      logger.i('تم جلب البيانات بنجاح');
      List<dynamic> jsonResponse = json.decode(response.body);

      // تحويل البيانات إلى قائمة من PlayerModel
      return jsonResponse.map((data) {
        return PlayerModel.fromJson(data);
      }).toList();
    } else {
      // إذا كانت الاستجابة غير ناجحة
      logger.e('فشل في جلب البيانات: ${response.statusCode}');
      throw Exception('فشل في تحميل بيانات اللاعبين.');
    }
  } catch (error) {
    // طباعة الخطأ في الكونسول
    logger.e('خطأ أثناء جلب البيانات: $error');
    
    // إعادة الخطأ ليتم التعامل معه
    throw Exception('تعذر جلب البيانات. تأكد من الاتصال بالإنترنت.');
  }
}
