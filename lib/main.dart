import 'package:bloc/bloc.dart';
import 'package:fifa_card_quiz/moduls/Home%20Page/home_page.dart';
import 'package:flutter/material.dart';

import 'BlocObserver.dart';

void main() {
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FIFA CARD QUIZ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomePage(),
    );
  }
}

// class PlayerCardPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: color3,
//       body: Center(
//         child: buildPlayerCard(),
//       ),
//     );
//   }
