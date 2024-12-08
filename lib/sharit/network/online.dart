
import 'dart:convert';

import '../../models/PalyerModel.dart';
import 'package:http/http.dart' as http;


Future<List<PlayerModel>> fetchPlayerData() async {
  // emit(PlayerLoadingState());
  final response = await http.get(Uri.parse(
      'https://guesstheplayer.site/player22.json'));

  if (response.statusCode == 200) {
    print('تم جلب البينات');
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) {
      return PlayerModel.fromJson(data);
      // emit(PlayerSuccessState(jsonResponse as PlayerModel));

    }).toList();

  } else {
    // emit(PlayerErrorState(''));
    throw Exception('Failed to load player data');
  }
}

