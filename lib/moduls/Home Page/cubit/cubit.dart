import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_the_player/moduls/Home%20Page/cubit/states.dart';

import '../../../models/PalyerModel.dart';
import '../PlayerModelList.dart';

class BlurCubit extends Cubit<BlurStates> {
  BlurCubit() : super(BlurInitialState(20)); // قيمة البداية 20
  int wrongAnswersCount  = 0; // عدد الإجابات الصحيحة
  double blurLevel = 20; // مستوى التمويه
  bool isFullyRevealed = false; // هل البطاقة مكشوفة بالكامل؟


  static BlurCubit get(context)=> BlocProvider.of(context);

  PlayerModel? playerModel;
  final dio = Dio();



  Future<void> fetchData() async {
    try {
      // إنشاء مثيل من Dio
      Dio dio = Dio();

      // إجراء طلب GET
      final response = await dio.get('https://gist.githubusercontent.com/MohammedAbed3/27663f0d445d1a915e10d46f033a4303/raw/3c2ede8d7d0744e2281003aa09e30d9ea56fd42c/gistfile1.txt'); // Replace with your actual API URL
          //');

      // تحقق من استجابة الـ API
      if (response.statusCode == 200) {
        print('البيانات: ${response.data}');
        playerModel= PlayerModel.fromJson(response.data);
      } else {
        print('فشل الاتصال: ${response.statusCode}');
      }
    } catch (e) {
      print('حدث خطأ: $e');
    }
  }





  // void getPlayerData() async {
  //   emit(PlayerLoadingState());
  //   final dio = Dio();
  //   const String jsonUrl = 'https://gist.githubusercontent.com/MohammedAbed3/27663f0d445d1a915e10d46f033a4303/raw/3c2ede8d7d0744e2281003aa09e30d9ea56fd42c/gistfile1.txt'; // Replace with your actual API URL
  //
  //   try {
  //     final response = await dio.get(jsonUrl);
  //
  //     if (response.statusCode == 200) {
  //       final data = response.data;
  //       if (data != null) {
  //         try {
  //           // Crucial change: Use PlayerModelList.fromJson() to parse the array
  //            playerModel = PlayerModel.fromJson(data);
  //           emit(PlayerSuccessState(playerModel!));
  //         } on FormatException catch (e) {
  //           print("JSON Format Error: ${e.message}"); //More specific error
  //           emit(PlayerErrorState("Invalid JSON data received."));
  //         } on dynamic catch (e) { // Catch any other parsing errors
  //           print("JSON Parsing Error: ${e.toString()}");
  //           emit(PlayerErrorState("Error parsing player list."));
  //         }
  //       } else {
  //         emit(PlayerErrorState('Received empty or null data from the server.'));
  //       }
  //     } else {
  //       emit(PlayerErrorState('Server error: Status code ${response.statusCode}'));
  //     }
  //   } on DioError catch (e) {
  //     print("Dio Error: ${e.message}");
  //     emit(PlayerErrorState('Network error: ${e.message}')); //More informative network errors
  //   } catch (e) {
  //     print('Unexpected Error: ${e.toString()}'); //For debugging
  //     emit(PlayerErrorState('An unexpected error occurred.'));
  //   }
  // }


  // تقليل درجة التمويه
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

