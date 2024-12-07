
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_the_player/moduls/Home%20Page/cubit/states.dart';

import '../../../models/PalyerModel.dart';

class BlurCubit extends Cubit<BlurStates> {
  BlurCubit() : super(BlurInitialState(20)); // قيمة البداية 20
  int wrongAnswersCount  = 0; // عدد الإجابات الصحيحة
  double blurLevel = 20; // مستوى التمويه
  bool isFullyRevealed = false; // هل البطاقة مكشوفة بالكامل؟


  static BlurCubit get(context)=> BlocProvider.of(context);

  PlayerModel? playerModel;



  Future<List<PlayerModel>> fetchPlayerData() async {
    emit(PlayerLoadingState());
    final response = await http.get(Uri.parse(
        'https://guesstheplayer.site/player22.json'));

    if (response.statusCode == 200) {
      print('تم جلب البينات');
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) {
        return PlayerModel.fromJson(data);
        emit(PlayerSuccessState(jsonResponse as PlayerModel));

      }).toList();

    } else {
      emit(PlayerErrorState(''));
      throw Exception('Failed to load player data');
    }
  }








  void decreaseBlur() {
    double currentBlur = (state is BlurUpdatedState)
        ? (state as BlurUpdatedState).blurLevel
        : (state as BlurInitialState).blurLevel;



    if (currentBlur > 0) {
      emit(BlurUpdatedState(currentBlur - 5));
    }
  }

  //
  // إعادة ضبط درجة التمويه


  void resetBlur() {
    emit(BlurInitialState(20));
  }



  void incrementWrongAnswers() {
    if (!isFullyRevealed) {
      wrongAnswersCount++;
      emit(BlurUpdatedState(blurLevel));
    }
  }

  void revealAll() {
    isFullyRevealed = true;
    emit(BlurUpdatedState(0)); // إزالة التمويه
  }
}

