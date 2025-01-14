import 'dart:math';
import 'package:blur/blur.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guess_the_player/moduls/Home%20Page/cubit/cubit.dart';
import 'package:guess_the_player/moduls/Home%20Page/cubit/states.dart';
import 'package:guess_the_player/sharit/Component.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../models/PalyerModel.dart';
import '../../style/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nameController = TextEditingController();
  // الاسم الصحيح للتحقق
  var formKey = GlobalKey<FormState>();
  String? errorMessage;
  List<PlayerModel> searchedPlayers = [];
  TextStyle positiveColorStyle =
      const TextStyle(color: Colors.redAccent, fontSize: 20);
  TextStyle neg = const TextStyle(color: Colors.black, fontSize: 20);
  final clubImage =
      'https://s3-us-west-2.amazonaws.com/s.cdpn.io/214624/Juventus_Logo.png';
  double blurLevel = 20;
  bool expand = false;
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
            if (kDebugMode) {
              print('Loading...');
            }
            return const Center(child: CircularProgressIndicator());
          } else if (state is PlayerErrorState) {
            return Center(child: Text('خطأ: ${state.message}'));
          } else {
            return Scaffold(
              resizeToAvoidBottomInset: true,
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
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      ClipPath(
                        clipper: MyClipper(),
                        child: Container(
                          width: min(kIsWeb ? 340 : 300,
                              MediaQuery.of(context).size.width * .8),
                          height:
                              min(500, MediaQuery.of(context).size.height * .9),
                          decoration: BoxDecoration(
                            color: Color(0xFFfdeaa7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Column(
                                children: [
                                  // First section - Player information and image
                                  Container(
                                    width: min(340,
                                        MediaQuery.of(context).size.width * .8),
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFFfdeaa7),
                                          Color(0xFFCDA549),
                                        ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 15, 15, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(width: 10),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Blur(
                                                blur: /*cubit.isFullyRevealed ||
                                                        cubit.wrongAnswersCount >= 4
                                                    ? 0
                                                    : 2*/
                                                    0,
                                                blurColor: color1,
                                                colorOpacity: 0,
                                                child: Text(
                                                  player.overallRating
                                                      .toString(), // Positions
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.w700,
                                                    color: color3,
                                                  ),
                                                ),
                                              ),
                                              Blur(
                                                blur: /* cubit.isFullyRevealed ||
                                                        cubit.wrongAnswersCount >= 4
                                                    ? 0
                                                    : 2 */
                                                    0,
                                                blurColor: color1,
                                                colorOpacity: 0,
                                                child: Text(
                                                  player.position
                                                      .shortLabel, // Positions
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w500,
                                                    color: color3,
                                                  ),
                                                ),
                                              ),
                                              whiteLine(width: 50, height: 2),
                                              const SizedBox(height: 4),
                                              Blur(
                                                blur: /* cubit.isFullyRevealed ||
                                                        cubit.wrongAnswersCount >= 3
                                                    ? 0
                                                    : 2 */
                                                    0,
                                                blurColor: color1,
                                                colorOpacity: 0,
                                                child: Image.network(
                                                  player.nationality.imageUrl,
                                                  height: 28,
                                                ),
                                              ),
                                              whiteLine(width: 50, height: 2),
                                              const SizedBox(height: 4),
                                              Blur(
                                                blur: /* cubit.isFullyRevealed ||
                                                        cubit.wrongAnswersCount >= 6
                                                    ? 0
                                                    : 2 */
                                                    0,
                                                blurColor: color1,
                                                colorOpacity: 0,
                                                child: Image.network(
                                                  player.team.imageUrl,
                                                  width: 40,
                                                  height: 40,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // const SizedBox(height: 4),
                                          //  whiteLine(width: 90, height: 0.5),
                                          Blur(
                                            blur: /* cubit.isFullyRevealed ||
                                                    cubit.wrongAnswersCount >= 5
                                                ? 0
                                                : 2 */
                                                0,
                                            blurColor: color1,
                                            colorOpacity: 0,
                                            child: Image.network(
                                              player.avatarUrl,
                                              height: 200,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                } else {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              (loadingProgress
                                                                      .expectedTotalBytes ??
                                                                  1)
                                                          : null,
                                                    ),
                                                  );
                                                }
                                              },
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                return const Icon(
                                                  Icons.error,
                                                  size: 50,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Second section - Player name and stats
                                  Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Color(0xFFfdeaa7),
                                          Color(0xFFe1c072)
                                        ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 0, 15, 15),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 10),
                                          _buildBlurText(
                                            /* cubit.isFullyRevealed ||
                                                cubit.wrongAnswersCount >= 7 */
                                            true,
                                            player.commonName ??
                                                player.firstName,
                                            kIsWeb ? 28 : 24,
                                          ),
                                          const SizedBox(height: 5),
                                          whiteLine(width: 200, height: 1),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              _buildStatsColumn(cubit, [
                                                {
                                                  'label': 'PAC',
                                                  'value': player.stats.pac,
                                                  'threshold': 1
                                                },
                                                {
                                                  'label': 'SHO',
                                                  'value': player.stats.sho,
                                                  'threshold': 1
                                                },
                                                {
                                                  'label': 'PAS',
                                                  'value': player.stats.pas,
                                                  'threshold': 1
                                                },
                                              ]),
                                              whiteLine(width: 1, height: 150),
                                              _buildStatsColumn(cubit, [
                                                {
                                                  'label': 'DRI',
                                                  'value': player.stats.dri,
                                                  'threshold': 2
                                                },
                                                {
                                                  'label': 'DEF',
                                                  'value': player.stats.def,
                                                  'threshold': 2
                                                },
                                                {
                                                  'label': 'PHY',
                                                  'value': player.stats.phy,
                                                  'threshold': 2
                                                },
                                              ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      //search
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
                              borderRadius: searchedPlayers.isNotEmpty
                                  ? const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))
                                  : BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            // تخصيص الرسالة في حالة الخطأ
                            errorStyle: const TextStyle(
                                color: Colors.red, fontSize: 14),
                            // تلوين الحافة عند وجود خطأ
                            focusedBorder: OutlineInputBorder(
                              borderRadius: searchedPlayers.isNotEmpty
                                  ? const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))
                                  : BorderRadius.circular(10),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            onSubmit(context, player);
                          },
                          onChanged: (value) async {
                            if (value.isNotEmpty) {
                              await cubit.search(value).then((out) {
                                setState(() {
                                  searchedPlayers = out ?? [];
                                });
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال اسم اللاعب';
                            }
                            return null; // إذا كانت القيمة صالحة
                          },
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ),
                      if (searchedPlayers.isNotEmpty &&
                          nameController.text != '')
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: searchOutput(cubit, player),
                        ),
                      const SizedBox(height: 25),
                      //btn
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFfdeaa7),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 80,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          if (cubit.getNext) {
                            // get next player
                            cubit.nextPlayer();
                          } else {
                            onSubmit(context, player);
                          }
                        },
                        child: Text(
                          cubit.getNext ? "التالي" : "تحقق",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
                footerWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding footerWidget() {
    Widget container(Widget child) {
      return Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'FOLLOW US FOR MORE GAMES',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: kIsWeb
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: kIsWeb ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
                child: GestureDetector(
                    onTap: () {
                      launchUrl(emailUrl, mail: true);
                    },
                    child: SvgPicture.asset(
                      'assets/svgs/gmail.svg',
                      color: Colors.white,
                      height: 30,
                    )),
              ),
              Padding(
                padding: kIsWeb ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
                child: GestureDetector(
                  onTap: () {
                    launchUrl(discordUrl);
                  },
                  child: SvgPicture.asset(
                    'assets/svgs/discord.svg',
                    color: Colors.white,
                    height: 30,
                  ),
                ),
              ),
              Padding(
                padding: kIsWeb ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
                child: GestureDetector(
                  onTap: () {
                    launchUrl(telegramUrl);
                  },
                  child: SvgPicture.asset(
                    'assets/svgs/telegram.svg',
                    color: Colors.white,
                    height: 30,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          const SizedBox(height: 5),
          whiteLine(width: MediaQuery.of(context).size.width * .8, height: 1),
          const SizedBox(height: 25),
          RichText(
            text: const TextSpan(
                text: '© 2024 FIFA CARD QUIZ \\\\  ',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                      text:
                          'All logos and brands are property of their respective owners and are used for identification purposes only',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white60,
                        fontSize: 14,
                      )),
                ]),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildBlurText(bool isRevealed, String text, double fontSize) {
    return Blur(
      blur: isRevealed ? 0 : 20,
      blurColor: color1,
      colorOpacity: 0,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Roboto Condensed',
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          color: color3,
        ),
      ),
    );
  }

  Widget _buildStatsColumn(cubit, List<Map<String, dynamic>> stats) {
    return Column(
      children: stats.map((stat) {
        return Column(
          children: [
            Row(
              children: [
                Text(
                  stat['label'],
                  style: TextStyle(
                    fontFamily: 'Roboto Condensed',
                    fontSize: 22,
                    color: color3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                _buildBlurText(
                  cubit.isFullyRevealed ||
                      cubit.wrongAnswersCount >= stat['threshold'],
                  stat['value'].toString(),
                  20,
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        );
      }).toList(),
    );
  }

  Widget searchOutput(BlurCubit cubit, PlayerModel player) {
    return Container(
      width: 300,
      height: searchedPlayers.length > 4 ? 340 : null,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: searchedPlayers.isNotEmpty
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))
            : BorderRadius.circular(10),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: cubit.searchedPlayers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Image.network(
                    cubit.searchedPlayers[index].team.imageUrl,
                    height: 35,
                  ), // إضافة أيقونة في بداية السطر (اختياري)
                  title: RichText(
                      text: searchMatch(
                          '${cubit.searchedPlayers[index].firstName} ${cubit.searchedPlayers[index].lastName}')), // النص الرئيسي

                  onTap: () {
                    // عند الضغط على العنصر، يمكن تنفيذ أي إجراء مثل الانتقال إلى صفحة أخرى
                    print('تم الضغط على اللاعب');
                    setState(() {
                      nameController.text =
                          '${cubit.searchedPlayers[index].firstName} ${cubit.searchedPlayers[index].lastName}';
                    });
                    onSubmit(context, player);
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  color: Colors.black,
                  width: 280,
                  height: .5,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  TextSpan searchMatch(String match) {
    if (nameController.text.toLowerCase().isEmpty) {
      return TextSpan(text: match, style: neg);
    }
    var refinedMatch = match.toLowerCase();
    var refinedSearch = nameController.text.toLowerCase();
    if (refinedMatch.contains(refinedSearch)) {
      if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
        return TextSpan(
          style: positiveColorStyle,
          text: match.substring(0, refinedSearch.length),
          children: [
            searchMatch(
              match.substring(
                refinedSearch.length,
              ),
            ),
          ],
        );
      } else if (refinedMatch.length == refinedSearch.length) {
        return TextSpan(text: match, style: positiveColorStyle);
      } else {
        return TextSpan(
          style: neg,
          text: match.substring(
            0,
            refinedMatch.indexOf(refinedSearch),
          ),
          children: [
            searchMatch(
              match.substring(
                refinedMatch.indexOf(refinedSearch),
              ),
            ),
          ],
        );
      }
    } else if (!refinedMatch.contains(refinedSearch)) {
      return TextSpan(text: match, style: neg);
    }
    return TextSpan(
      text: match.substring(0, refinedMatch.indexOf(refinedSearch)),
      style: positiveColorStyle,
      children: [
        searchMatch(match.substring(refinedMatch.indexOf(refinedSearch)))
      ],
    );
  }

  void onSubmit(BuildContext context, PlayerModel player) {
    final enteredName = nameController.text.trim().toLowerCase();
    print('enteredName: $enteredName');
    print('matching: ${player.lastName.toLowerCase()}');

    print('onSubmitssssss');
    if (formKey.currentState?.validate() ?? false) {
      if (('${player.firstName.toLowerCase()} ${player.lastName.toLowerCase()}')
          .contains(enteredName)) {
        nameController.clear();
        print('right');
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
        print('Wrong');

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

  String telegramUrl = 'https://t.me/fifacardquiz';
  String emailUrl = 'marimeltaweel26@gmail.com';
  String discordUrl = 'https://discord.gg/JBvjPf5R';

  void launchUrl(String url, {bool mail = false}) async {
    final Uri params = Uri(
        scheme: 'mailto',
        path: url,
        query: 'subject=Default Subject&body=DefaultBody');
    if (mail == true) {
      if (await canLaunchUrl(params)) {
        await launchUrlString(params.toString());
      }
    } else {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrlString(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    double w = size.width;
    double h = size.height;

    //Start from the top left  at (15% height, zero width).
    path.moveTo(0, .12 * h);
    //down to bottom left at (85% height, zero width).
    path.lineTo(0, .85 * h);

    //// doing the bottom left curve.
    //with two quadratic.
    path.quadraticBezierTo(0, .87 * h, .1 * w, .89 * h);
    path.quadraticBezierTo(.48 * w, .95 * h, .5 * w, h);
    //// doing the bottom right curve.
    /////with two quadratic.
    path.quadraticBezierTo(.52 * w, .95 * h, .9 * w, .89 * h);
    path.quadraticBezierTo(w, .87 * h, w, .85 * h);

    //up to top right at (15% height, 100% width).
    path.lineTo(w, .12 * h);

    //// doing the top right design curve.
    //with three quadratic.
    path.quadraticBezierTo(.95 * w, .125 * h, .75 * w, .03 * h);
    path.quadraticBezierTo(.65 * w, 0, .6 * w, .03 * h);
    path.quadraticBezierTo(.54 * w, .05 * h, .5 * w, 0);
    //// doing the top left design curve.
    //with three quadratic.
    path.quadraticBezierTo(.46 * w, .05 * h, .4 * w, .03 * h);
    path.quadraticBezierTo(.35 * w, 0, .25 * w, .03 * h);
    path.quadraticBezierTo(.05 * w, .125 * h, 0, .12 * h);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // لا نحتاج لإعادة القص بعد التحديثات
  }
}
