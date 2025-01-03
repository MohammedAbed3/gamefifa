import 'dart:math';

import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:guess_the_player/moduls/Home%20Page/PlayerService.dart';
import 'package:guess_the_player/moduls/Home%20Page/cubit/cubit.dart';
import 'package:guess_the_player/moduls/Home%20Page/cubit/states.dart';

import '../../models/PalyerModel.dart';
import '../../sharit/Component.dart';
import '../../style/color.dart';

class HomePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  // الاسم الصحيح للتحقق
  var formKey = GlobalKey<FormState>();

  bool isLoading = true;

  String? errorMessage;

  final clubImage =
      'https://s3-us-west-2.amazonaws.com/s.cdpn.io/214624/Juventus_Logo.png';

  double blurLevel = 20;

  HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlurCubit()..fetchPlayer(),
      child: BlocConsumer<BlurCubit, BlurStates>(
        builder: (context, state) {
          BlurCubit cubit = BlurCubit.get(context);
          double blurLevel = 20; // مستوى الضبابية الافتراضي

          if (state is BlurUpdatedState) {
            blurLevel = state.blurLevel;
          } else if (state is BlurInitialState) {
            blurLevel = state.blurLevel; // قد ترغب في وضع قيمة افتراضية هنا
          }

          if (state is PlayerLoadingState) {
            print('herrr');
            return const Center(child: CircularProgressIndicator());
          } else if (state is PlayerErrorState) {
            return Center(child: Text('خطأ: ${state.message}'));
          } else {
            // print('PlayerSuccessState ${players.length}');
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: playerItemCard(
                cubit: cubit,
                context: context,
              ),
            );
          }
        },
        listener: (context, state) {},
      ),
    );
  }

  Widget playerItemCard(
      {required BlurCubit cubit, required BuildContext context}) {
    var player = cubit.playerModel;
    if (player == null) {
      return const Text("Error");
    }

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center, // بداية التدرج من المركز
          radius: 1.0, // التدرج يبدأ من النص ويذهب إلى الأطراف
          colors: [
            cubit.isFullyRevealed ? greenDark : redDark, // اللون في المركز

            Colors.black, // اللون عند الأطراف
          ],
        ),
      ),
      child: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    width: min(350, MediaQuery.of(context).size.width * .8),
                    height: min(500, MediaQuery.of(context).size.height * .8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // First section - Player information and image
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFfdeaa7), Color(0xFFe1c072)],
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Blur(
                                    blur: cubit.isFullyRevealed ||
                                            cubit.wrongAnswersCount >= 6
                                        ? 0
                                        : 20,
                                    blurColor: color1,
                                    colorOpacity: 0,
                                    child: FittedBox(
                                      child: Image.network(
                                        "${player.team.imageUrl}",
                                        width: 30,
                                        height: 30,
                                        // style: TextStyle(
                                        //   fontSize: 40,
                                        //   fontWeight: FontWeight.bold,
                                        //   color: color3,
                                        // ),
                                      ),
                                    ),
                                  ),
                                  Blur(
                                    blur: cubit.isFullyRevealed ||
                                            cubit.wrongAnswersCount >= 4
                                        ? 0
                                        : 20,
                                    blurColor: color1,
                                    colorOpacity: 0,
                                    child: Text(
                                      player.position.shortLabel, // Positions
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                        color: color3,
                                      ),
                                    ),
                                  ),
                                  whiteLine(width: 50, height: 0.5),
                                  const SizedBox(height: 10),
                                  Blur(
                                      blur: cubit.isFullyRevealed ||
                                              cubit.wrongAnswersCount >= 3
                                          ? 0
                                          : 20,
                                      blurColor: color1,
                                      colorOpacity: 0,
                                      child: Image.network(
                                          player.nationality.imageUrl,
                                          height: 25)),
                                  const SizedBox(height: 10),
                                  whiteLine(width: 50, height: 0.5),
                                  Blur(
                                      blur: cubit.isFullyRevealed ||
                                              cubit.wrongAnswersCount >= 5
                                          ? 0
                                          : 20,
                                      blurColor: color1,
                                      colorOpacity: 0,
                                      child: Image.network(player.avatarUrl))
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Second section - Player name and stats
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFfdeaa7), Color(0xFFe1c072)],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Blur(
                                      blur: cubit.isFullyRevealed ||
                                              cubit.wrongAnswersCount >= 7
                                          ? 0
                                          : 20,
                                      blurColor: color1,
                                      colorOpacity: 0,
                                      child: Text(
                                        player.commonName ?? player.lastName ?? player.firstName ?? '',
                                        style: TextStyle(
                                          fontFamily: 'Roboto Condensed',
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: color3,
                                        ),
                                      ),
                                    ),
                                    whiteLine(width: 200, height: 0.5),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // العمود الأول
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'PAC',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Roboto Condensed',
                                                    fontSize: 20,
                                                    color: color3,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Blur(
                                                  blur: cubit.isFullyRevealed ||
                                                          cubit.wrongAnswersCount >=
                                                              1
                                                      ? 0
                                                      : 20,
                                                  blurColor: color1,
                                                  colorOpacity: 0,
                                                  child: Text(
                                                    player.stats.pac.toString(),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Roboto Condensed',
                                                      fontSize: 20,
                                                      color: color3,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  'SHO',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Roboto Condensed',
                                                    fontSize: 20,
                                                    color: color3,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Blur(
                                                  blur: cubit.isFullyRevealed ||
                                                          cubit.wrongAnswersCount >=
                                                              1
                                                      ? 0
                                                      : 20,
                                                  blurColor: color1,
                                                  colorOpacity: 0,
                                                  child: Text(
                                                    player.stats.sho.toString(),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Roboto Condensed',
                                                      fontSize: 20,
                                                      color: color3,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  'PAS',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Roboto Condensed',
                                                    fontSize: 20,
                                                    color: color3,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Blur(
                                                  blur: cubit.isFullyRevealed ||
                                                          cubit.wrongAnswersCount >=
                                                              1
                                                      ? 0
                                                      : 20,
                                                  blurColor: color1,
                                                  colorOpacity: 0,
                                                  child: Text(
                                                    player.stats.pas.toString(),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Roboto Condensed',
                                                      fontSize: 20,
                                                      color: color3,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        // العمود الثاني
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'DRI',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Roboto Condensed',
                                                    fontSize: 20,
                                                    color: color3,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Blur(
                                                  blur: cubit.isFullyRevealed ||
                                                          cubit.wrongAnswersCount >=
                                                              2
                                                      ? 0
                                                      : 20,
                                                  blurColor: color1,
                                                  colorOpacity: 0,
                                                  child: Text(
                                                    player.stats.dri.toString(),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Roboto Condensed',
                                                      fontSize: 20,
                                                      color: color3,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  'DEF',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Roboto Condensed',
                                                    fontSize: 20,
                                                    color: color3,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Blur(
                                                  blur: cubit.isFullyRevealed ||
                                                          cubit.wrongAnswersCount >=
                                                              2
                                                      ? 0
                                                      : 20,
                                                  blurColor: color1,
                                                  colorOpacity: 0,
                                                  child: Text(
                                                    player.stats.def.toString(),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Roboto Condensed',
                                                      fontSize: 20,
                                                      color: color3,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  'PHY',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Roboto Condensed',
                                                    fontSize: 20,
                                                    color: color3,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Blur(
                                                  blur: cubit.isFullyRevealed ||
                                                          cubit.wrongAnswersCount >=
                                                              2
                                                      ? 0
                                                      : 20,
                                                  blurColor: color1,
                                                  colorOpacity: 0,
                                                  child: Text(
                                                    player.stats.phy.toString(),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Roboto Condensed',
                                                      fontSize: 20,
                                                      color: color3,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "أدخل اسم اللاعب",
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      // تخصيص الرسالة في حالة الخطأ
                      errorStyle:
                      const TextStyle(color: Colors.red, fontSize: 14),
                      // تلوين الحافة عند وجود خطأ
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                        const BorderSide(color: Colors.blue, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                        const BorderSide(color: Colors.red, width: 2),
                      ),
                      // إضافة أيقونة في ح.\env\Scripts\Activateالة الخطأ
                    ),
                    onFieldSubmitted: (value) {
                      onSubmit(context, player);
                    },

                    onChanged: (value) {
                      if (value.isNotEmpty) {

                        ListTile(

                          leading: Icon(Icons.person),  // إضافة أيقونة في بداية السطر (اختياري)
                          title: Text('اسم اللاعب'),    // النص الرئيسي
                          subtitle: Text('جنسية اللاعب'), // النص الفرعي تحت العنوان
                          trailing: Icon(Icons.arrow_forward), // إضافة أيقونة في النهاية (اختياري)
                          onTap: () {
                            // عند الضغط على العنصر، يمكن تنفيذ أي إجراء مثل الانتقال إلى صفحة أخرى
                            print('تم الضغط على اللاعب');
                          },
                        );

                      }

                      // PopupMenuButton<String>(
                      //   icon: Icon(Icons.arrow_drop_down),
                      //   onSelected: (String value) {
                      //     // عند اختيار النص من القائمة، تعيينه في الـ TextField
                      //
                      //     // يمكن تنفيذ أي إجراء آخر هنا، مثل تسجيل الاختيار أو أي منطق آخر
                      //   },
                      //   itemBuilder: (BuildContext context) {
                      //     return suggestions.map((String value) {
                      //       return PopupMenuItem<String>(
                      //         value: value,
                      //         child: Text(value),
                      //       );
                      //     }).toList();
                      //   },
                      // );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال اسم اللاعب';
                      }
                      return null; // إذا كانت القيمة صالحة
                    },
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  )
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (cubit.getNext) {
                      // get next player
                      cubit.nextPlayer();
                    } else {
                      onSubmit(context, player);
                    }
                  },
                  child: Text(cubit.getNext ? "التالي" : "تحقق"),
                ),
                // ElevatedButton(
                //   onPressed: () async {
                //     // PlayerModel player = await loadPlayerData();
                //     // print('Player: ${player.firstName} ${player.lastName}');
                //     // print('Club: ${player.club}');
                //     // print('Country: ${player.country}');
                //     // print('Position: ${player.position}');
                //     // print('Total Rating: ${player.totalRating}');
                //     // print(player.firstName);
                //   },
                //   child: const Text("التالي"),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSubmit(BuildContext context, PlayerModel player) {
    final enteredName = nameController.text.trim().toLowerCase();

    print('onSubmitssssss');
    if (formKey.currentState?.validate() ?? false) {
      if (enteredName == player.lastName.toLowerCase()) {
        // إذا كانت الإجابة صحيحة
        context.read<BlurCubit>().revealAll();
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content:
        //         Text("إجابة صحيحة!", style: TextStyle(color: Colors.white)),
        //     backgroundColor: Colors.green,
        //   ),
        // );
      } else {
        // إذا كانت الإجابة خاطئة
        nameController.clear();
        print('غلطط');

        context.read<BlurCubit>().incrementWrongAnswers();
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content:
        //         Text("إجابة خاطئة!", style: TextStyle(color: Colors.white)),
        //     backgroundColor: Colors.red,
        //   ),
        // );
      }
    }
  }

  // void _showSuggestions(BuildContext context) {
  Widget buildStatsColumn(List<Map<String, dynamic>> stats) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: stats.map((stat) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              stat['label'],
              style: TextStyle(
                fontFamily: 'Roboto Condensed',
                fontSize: 24,
                color: color3,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              '${stat['value']}',
              style: TextStyle(
                fontFamily: 'Roboto Condensed',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color3,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // البدء من الزاوية العليا
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);

    // رسم الحافة العلوية
    path.lineTo(size.width, size.height - 30);

    // إنشاء منحنى في الحافة السفلى اليمنى
    path.quadraticBezierTo(
        size.width - 40, size.height, size.width - 80, size.height);

    // رسم الحافة السفلى
    path.lineTo(80, size.height);

    // إنشاء منحنى في الحافة السفلى اليسرى
    path.quadraticBezierTo(0, size.height - 30, 0, size.height - 30);

    // إغلاق المسار
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // لا نحتاج لإعادة القص بعد التحديثات
  }
}
