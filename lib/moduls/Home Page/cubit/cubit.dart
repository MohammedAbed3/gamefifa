import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_the_player/moduls/Home%20Page/cubit/states.dart';

import '../../../models/PalyerModel.dart';
import '../../../sharit/network/online.dart';

class BlurCubit extends Cubit<BlurStates> {
  BlurCubit() : super(BlurInitialState(20)); // قيمة البداية 20
  int wrongAnswersCount = 0; // عدد الإجابات الصحيحة
  double blurLevel = 20; // مستوى التمويه
  bool isFullyRevealed = false; // هل البطاقة مكشوفة بالكامل؟

  static BlurCubit get(context) => BlocProvider.of(context);

  List<PlayerModel> players = [];

  PlayerModel? playerModel;

  bool getNext = false;

  int? index;

  Future<List<PlayerModel>?> fetchPlayer() async {
    try {
      // تخيل أنه يتم جلب اللاعب هنا من API أو قاعدة بيانات.
      players = await fetchPlayerData();

      playerModel = players.firstOrNull;

      index = 0;
      emit(PlayerSuccessState(players));

      return players;
    } catch (error) {
      emit(PlayerErrorState(error.toString()));
      return null;
    }
  }

  nextPlayer() {
    index = index! + 1;
    playerModel = players[index!];
    isFullyRevealed = false;
    getNext = false;
    wrongAnswersCount = 0;

    resetBlur();
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
      if (wrongAnswersCount == 6) {
        getNext = true;
      }

      emit(BlurUpdatedState(blurLevel));
    }
  }

  void revealAll() {
    isFullyRevealed = true;
    getNext = true;
    emit(BlurUpdatedState(0)); // إزالة التمويه
  }
}
