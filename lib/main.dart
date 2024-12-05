import 'package:flutter/material.dart';
import 'package:guess_the_player/moduls/Home%20Page/home_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Player Card',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePage(),
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





