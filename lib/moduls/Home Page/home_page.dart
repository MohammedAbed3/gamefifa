import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_the_player/moduls/Home%20Page/cubit/cubit.dart';
import 'package:guess_the_player/moduls/Home%20Page/cubit/states.dart';

import '../../models/PalyerModel.dart';
import '../../sharit/Component.dart';
import '../../style/color.dart';

class HomePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final String correctName = "Ronaldo"; // الاسم الصحيح للتحقق

  var formKey = GlobalKey<FormState>();

  final playerImage =
      'https://s3-us-west-2.amazonaws.com/s.cdpn.io/214624/Ronaldo.png';
  final countryImage =
      'https://s3-us-west-2.amazonaws.com/s.cdpn.io/214624/portugal.png';
  final clubImage =
      'https://s3-us-west-2.amazonaws.com/s.cdpn.io/214624/Juventus_Logo.png';
  double blurLevel = 20;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlurCubit()..fetchPlayerData(),
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
            return Center(child: CircularProgressIndicator());
          } else if (state is PlayerSuccessState) {
            final players = state.player;
            print('PlayerSuccessState ببب');

            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center, // بداية التدرج من المركز
                    radius: 1.0, // التدرج يبدأ من النص ويذهب إلى الأطراف
                    colors: [
                      cubit.isFullyRevealed
                          ? greenDark
                          : redDark, // اللون في المركز

                      Colors.black, // اللون عند الأطراف
                    ],
                  ),
                ),
                child: Center(
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          ClipPath(
                            clipper: MyClipper(),
                            child: Container(
                              width: 270,
                              height: 430,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // First section - Player information and image
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFFfdeaa7),
                                            Color(0xFFe1c072)
                                          ],
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Blur(
                                                  blur: cubit.isFullyRevealed ||
                                                      cubit.wrongAnswersCount >=
                                                          6
                                                      ? 0
                                                      : 20,
                                                  blurColor: color1,
                                                  colorOpacity: 0,
                                                  child: Text(
                                                    '94',
                                                    style: TextStyle(
                                                      fontSize: 40,
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      color: color3,
                                                    ),
                                                  ),
                                                ),
                                                Blur(
                                                  blur: cubit.isFullyRevealed ||
                                                      cubit.wrongAnswersCount >=
                                                          4
                                                      ? 0
                                                      : 20,
                                                  blurColor: color1,
                                                  colorOpacity: 0,
                                                  child: Text(
                                                    'ST',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: color3,
                                                    ),
                                                  ),
                                                ),
                                                whiteLine(
                                                    width: 50, height: 0.5),
                                                SizedBox(height: 10),
                                                Blur(
                                                    blur: cubit
                                                        .isFullyRevealed ||
                                                        cubit
                                                            .wrongAnswersCount >=
                                                            3
                                                        ? 0
                                                        : 20,
                                                    blurColor: color1,
                                                    colorOpacity: 0,
                                                    child: Image.network(
                                                        countryImage,
                                                        height: 25)),
                                                SizedBox(height: 10),
                                                whiteLine(
                                                    width: 50, height: 0.5),
                                                Blur(
                                                    blur: cubit
                                                        .isFullyRevealed ||
                                                        cubit
                                                            .wrongAnswersCount >=
                                                            5
                                                        ? 0
                                                        : 20,
                                                    blurColor: color1,
                                                    colorOpacity: 0,
                                                    child: Image.network(
                                                        clubImage,
                                                        height: 60)),
                                              ],
                                            ),
                                          ),
                                          // Wrap the section inside Stack for positioning
                                          Expanded(
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  bottom:
                                                  0,
                                                  // Position the image at the bottom
                                                  right:
                                                  40,
                                                  // Position the image on the right
                                                  child: Blur(
                                                    blur: cubit
                                                        .isFullyRevealed ||
                                                        cubit
                                                            .wrongAnswersCount >=
                                                            7
                                                        ? 0
                                                        : 20,
                                                    blurColor: color1,
                                                    colorOpacity: 0,
                                                    child: Container(
                                                      width: 100,
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              playerImage),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Second section - Player name and stats
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFFfdeaa7),
                                            Color(0xFFe1c072)
                                          ],
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
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
                                                '{cubit.playerModel?.commonName}',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto Condensed',
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                  color: color3,
                                                ),
                                              ),
                                            ),
                                            whiteLine(width: 200, height: 0.5),
                                            SizedBox(height: 10),
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
                                                          'P:',
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'Roboto Condensed',
                                                            fontSize: 20,
                                                            color: color3,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Blur(
                                                          blur: cubit
                                                              .isFullyRevealed ||
                                                              cubit
                                                                  .wrongAnswersCount >=
                                                                  1
                                                              ? 0
                                                              : 20,
                                                          blurColor: color1,
                                                          colorOpacity: 0,
                                                          child: Text(
                                                            '89',
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
                                                    SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'SH:',
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'Roboto Condensed',
                                                            fontSize: 20,
                                                            color: color3,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Blur(
                                                          blur: cubit
                                                              .isFullyRevealed ||
                                                              cubit
                                                                  .wrongAnswersCount >=
                                                                  1
                                                              ? 0
                                                              : 20,
                                                          blurColor: color1,
                                                          colorOpacity: 0,
                                                          child: Text(
                                                            '{player.totalRating}',
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
                                                    SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'PA:',
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'Roboto Condensed',
                                                            fontSize: 20,
                                                            color: color3,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Blur(
                                                          blur: cubit
                                                              .isFullyRevealed ||
                                                              cubit
                                                                  .wrongAnswersCount >=
                                                                  1
                                                              ? 0
                                                              : 20,
                                                          blurColor: color1,
                                                          colorOpacity: 0,
                                                          child: Text(
                                                            '81',
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
                                                          'D:',
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'Roboto Condensed',
                                                            fontSize: 20,
                                                            color: color3,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Blur(
                                                          blur: cubit
                                                              .isFullyRevealed ||
                                                              cubit
                                                                  .wrongAnswersCount >=
                                                                  2
                                                              ? 0
                                                              : 20,
                                                          blurColor: color1,
                                                          colorOpacity: 0,
                                                          child: Text(
                                                            '90',
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
                                                    SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'DE:',
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'Roboto Condensed',
                                                            fontSize: 20,
                                                            color: color3,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Blur(
                                                          blur: cubit
                                                              .isFullyRevealed ||
                                                              cubit
                                                                  .wrongAnswersCount >=
                                                                  2
                                                              ? 0
                                                              : 20,
                                                          blurColor: color1,
                                                          colorOpacity: 0,
                                                          child: Text(
                                                            '33',
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
                                                    SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'PH:',
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'Roboto Condensed',
                                                            fontSize: 20,
                                                            color: color3,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Blur(
                                                          blur: cubit
                                                              .isFullyRevealed ||
                                                              cubit
                                                                  .wrongAnswersCount >=
                                                                  2
                                                              ? 0
                                                              : 20,
                                                          blurColor: color1,
                                                          colorOpacity: 0,
                                                          child: Text(
                                                            '83',
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
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: 300,
                            child: TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: "أدخل اسم اللاعب",
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                // تخصيص الرسالة في حالة الخطأ
                                errorStyle:
                                TextStyle(color: Colors.red, fontSize: 14),
                                // تلوين الحافة عند وجود خطأ
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  BorderSide(color: Colors.red, width: 2),
                                ),
                                // إضافة أيقونة في ح.\env\Scripts\Activateالة الخطأ
                              ),
                              onFieldSubmitted: (value) {
                                onSubmit(context);
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  // يمكن تعديل الشرط كما ترغب لعرض القائمة عند الحاجة
                                  // _showSuggestions(
                                  //     context); // إظهار القائمة عندما يتغير النص
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
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              onSubmit(context);
                            },
                            child: Text("تحقق"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // PlayerModel player = await loadPlayerData();
                              // print('Player: ${player.firstName} ${player.lastName}');
                              // print('Club: ${player.club}');
                              // print('Country: ${player.country}');
                              // print('Position: ${player.position}');
                              // print('Total Rating: ${player.totalRating}');
                            },
                            child: Text("تحقق"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }else if (state is PlayerErrorState) {
            return Center(child: Text('خطأ: ${state.message}'));
          } else {
            return Center(child: Text('حالة غير معروفة'));
          }

        },
        listener: (context, state) {},
      ),
    );
  }

  void onSubmit(BuildContext context) {
    final enteredName = nameController.text.trim().toLowerCase();

    if (formKey.currentState?.validate() ?? false) {
      if (enteredName == correctName.toLowerCase()) {
        // إذا كانت الإجابة صحيحة
        context.read<BlurCubit>().revealAll();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("إجابة صحيحة!", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // إذا كانت الإجابة خاطئة
        nameController.clear();

        context.read<BlurCubit>().incrementWrongAnswers();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("إجابة خاطئة!", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // void _showSuggestions(BuildContext context) {
  //   showMenu<String>(
  //     context: context,
  //     position: RelativeRect.fromLTRB(
  //         0, 50, 0, 0), // تحديد المكان الذي ستظهر فيه القائمة
  //     items: suggestions.map((String value) {
  //       return PopupMenuItem<String>(
  //         value: value,
  //         child: Text(value),
  //       );
  //     }).toList(),
  //   ).then((value) {
  //     if (value != null) {
  //       nameController.text =
  //           value; // تعيين النص في الـ TextField بعد اختيار العنصر
  //     }
  //   });
  // }

  Widget buildStatsColumn(List<Map<String, dynamic>> stats) {
    return Expanded(
      child: Column(
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
              SizedBox(width: 5),
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
      ),
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
