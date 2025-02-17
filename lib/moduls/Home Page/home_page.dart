import 'dart:math';
import 'dart:ui';
import 'package:fifa_card_quiz/sharit/Component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fifa_card_quiz/moduls/Home%20Page/ErrorPage.dart';
import 'package:fifa_card_quiz/moduls/Home%20Page/cubit/cubit.dart';
import 'package:fifa_card_quiz/moduls/Home%20Page/cubit/states.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../models/PalyerModel.dart';
import '../../style/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  var logger = Logger();

  // الاسم الصحيح للتحقق
  var formKey = GlobalKey<FormState>();
  String? errorMessage;
  List<PlayerModel> searchedPlayers = [];
  TextStyle positiveColorStyle =
      const TextStyle(color: Colors.redAccent, fontSize: 20);
  TextStyle neg = const TextStyle(color: Colors.black, fontSize: 20);

  double blurLevel = 20;

  late AnimationController threeErrController;
  late AnimationController fourErrController;
  late AnimationController firstErrController;
  late AnimationController secondErrController;
  late AnimationController fifthErrController;
  late AnimationController sixErrController;
  late AnimationController sevenErrController;

  String telegramUrl = 'https://t.me/fifacardquiz';
  String emailUrl = 'mo3bed4ads@gmail.com';
  String discordUrl = 'https://discord.gg/7kpYN4cD9M';
  String buyMeAoffee = 'https://buymeacoffee.com/mohammed3bb';

  @override
  void initState() {
    super.initState();
    sixErrController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    threeErrController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    fourErrController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    sevenErrController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    firstErrController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    secondErrController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    fifthErrController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  late double screenWidth;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => BlurCubit()..fetchPlayer(),
      child: BlocConsumer<BlurCubit, BlurStates>(
        builder: (context, state) {
          BlurCubit cubit = BlurCubit.get(context);

          if (state is BlurUpdatedState) {
            blurLevel = state.blurLevel;
          } else if (state is BlurInitialState) {
            blurLevel = state.blurLevel; // قد ترغب في وضع قيمة افتراضية هنا
          }
          if (state is PlayerLoadingState) {
            if (kDebugMode) {
              logger.i('Loading...');
            }
            return const Center(child: CircularProgressIndicator());
          } else if (state is PlayerErrorState) {
            // العودة إلى واجهة الخطأ
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ErrorPage(
                      errorMessage:
                          'Failed to load data. Please check your internet connection.',
                      onRetry: () async {
                        try {
                          // محاولة جلب البيانات
                          await cubit.fetchPlayer();

                          // تحقق من حالة الـ Cubit بعد محاولة جلب البيانات
                          if (cubit.state is PlayerSuccessState) {
                            // إذا كانت الحالة PlayerLoaded (أي البيانات تم تحميلها بنجاح)
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                              (route) => false, // إزالة جميع الصفحات السابقة
                            );
                          } else {
                            // إذا لم يتم تحميل البيانات بنجاح أو كانت هناك مشكلة
                            logger.e('Failed to load data');
                          }
                        } catch (e) {
                          // في حالة حدوث خطأ أثناء محاولة جلب البيانات
                          logger.e('Error: $e');
                          logger.e(
                              'An error occurred while trying to fetch the data');
                        }
                      }),
                ),
              );
            });
            return const SizedBox(); // إعادة Widget فارغ أثناء الانتقال
          } else {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              body: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center, // بداية التدرج من المركز
                        radius: 1.0, // التدرج يبدأ من النص ويذهب إلى الأطراف
                        colors: [
                          cubit.wrongAnswersCount == 0
                              ? color3
                              : (cubit.isFullyRevealed
                                  ? greenDark
                                  : redDark), // تغيير اللون بناءً على عدد الإجابات الغلط
                          Colors.black, // اللون عند الأطراف
                        ],
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: playerItemCard(
                        cubit: cubit,
                        context: context,
                      ),
                    ),
                  ),
                ],
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
      child: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              height: searchedPlayers.isNotEmpty && nameController.text != ''
                  ? MediaQuery.of(context).size.height + 400
                  : MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        ClipPath(
                          clipper: MyClipper(),
                          child: Container(
                            width: min(
                                300, MediaQuery.of(context).size.width * .8),
                            height: min(
                                500, MediaQuery.of(context).size.height * .9),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFfdeaa7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // First section - Player information and image
                                    Container(
                                      width: min(
                                          300,
                                          MediaQuery.of(context).size.width *
                                              .8),
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
                                                buildAnimatedBlur(
                                                  fourErrController,
                                                  cubit.isFullyRevealed ||
                                                      cubit.wrongAnswersCount >=
                                                          4,
                                                  child: Text(
                                                    player.overallRating
                                                        .toString(), // Positions
                                                    style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: color3,
                                                    ),
                                                  ),
                                                ),
                                                buildAnimatedBlur(
                                                  fifthErrController,
                                                 cubit.isFullyRevealed ||
                                                      cubit.wrongAnswersCount >=
                                                          5,
                                                  child: Stack(
                                                    children: [
                                                      Text(
                                                        player.position
                                                            .shortLabel, // Positions
                                                        style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: color3,
                                                        ),
                                                      ),
                                                      // if (cubit.hideImage )
                                                      //   Container(
                                                      //     width: 30,
                                                      //     height: 30,
                                                      //     color: Colors.black,
                                                      //   )
                                                    ],
                                                  ),
                                                ),
                                                whiteLine(width: 50, height: 2),
                                                const SizedBox(height: 4),
                                                buildAnimatedBlur(
                                                  threeErrController,
                                                  cubit.isFullyRevealed ||
                                                      cubit.wrongAnswersCount >=
                                                          3,
                                                  child: Stack(
                                                    children: [
                                                      Image.network(
                                                        player.nationality
                                                            .imageUrl,
                                                        height: 28,
                                                      ),
                                                      // if (cubit.hideImage)
                                                      //   Container(
                                                      //     width: 28,
                                                      //     height: 28,
                                                      //     color: Colors.black,
                                                      //   ),
                                                    ],
                                                  ),
                                                ),
                                                whiteLine(width: 50, height: 2),
                                                const SizedBox(height: 4),
                                                buildAnimatedBlur(
                                                  sixErrController,
                                                  cubit.isFullyRevealed ||
                                                      cubit.wrongAnswersCount >=
                                                          6,
                                                  child: Stack(
                                                    children: [
                                                      Image.network(
                                                        player.team.imageUrl,
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                                      // if (cubit.hideImage)
                                                      //   Container(
                                                      //     width: 40,
                                                      //     height: 40,
                                                      //     color: Colors.black,
                                                      //   ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            buildAnimatedBlur(
                                              sevenErrController,
                                              cubit.isFullyRevealed ||
                                                  cubit.wrongAnswersCount >= 7,
                                              child: Stack(
                                                alignment:
                                                    Alignment.centerRight,
                                                children: [
                                                  Image.network(
                                                    player.avatarUrl,
                                                    height: kIsWeb ? 180 : 200,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object error,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return const Icon(
                                                        Icons.error,
                                                        size: 50,
                                                      );
                                                    },
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
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
                                                  ),
                                                  // if (cubit.hideImage)
                                                  //   Container(
                                                  //     width: 160,
                                                  //     height: 180,
                                                  //     color: Colors.black,
                                                  //   ),
                                                ],
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
                                            Stack(
                                              children: [
                                                buildAnimationBlurText(
                                                  sevenErrController,
                                                  cubit.isFullyRevealed ||
                                                      cubit.wrongAnswersCount >=
                                                          7,
                                                  player.commonName ??
                                                      player.lastName ??
                                                      player.firstName,
                                                  kIsWeb ? 28 : 24,
                                                ),
                                                // if (cubit.hideImage)
                                                //   Container(
                                                //     width: 180,
                                                //     height: 35,
                                                //     color: Colors.black,
                                                //   ),
                                              ],
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
                                                whiteLine(
                                                    width: 1, height: 150),
                                                ssbuildStatsColumn(cubit, [
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
                              hintText: "Guess ${cubit.questionsCount} of 7",
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
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2),
                              ),
                            ),
                            onFieldSubmitted: (value) {
                              onSubmit(context, player, cubit);
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
                                return 'Please enter the player\'s name';
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
                        //btn
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: const Color(0xFFfdeaa7),
                        //     padding: const EdgeInsets.symmetric(
                        //       horizontal: 80,
                        //       vertical: 12,
                        //     ),
                        //   ),
                        //   onPressed: () {
                        //     if (cubit.getNext) {
                        //       setState(() {
                        //         threeErrController.reverse(); // Increase blur
                        //         fourErrController.reverse(); // Increase blur
                        //         sixErrController.reverse(); // Increase blur
                        //         sevenErrController.reverse(); // Increase blur
                        //       });
                        //       Future.delayed(const Duration(milliseconds: 300),
                        //           () {
                        //         setState(() {
                        //           cubit.nextPlayer();
                        //         });
                        //       });
                        //       // get next player
                        //     } else {
                        //       onSubmit(context, player, cubit);
                        //     }
                        //   },
                        //   child: Text(
                        //     cubit.getNext ? "التالي" : "تحقق",
                        //     style: const TextStyle(
                        //       color: Colors.black,
                        //       fontSize: 22,
                        //       fontWeight: FontWeight.w800,
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 30,
                        // ),
                        const SizedBox(
                          height: 30,
                        ),
                        if (cubit.isFullyRevealed)
                          SizedBox(
                            width: 300,
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFfdeaa7),
                              ),
                              onPressed: () {
                                if (cubit.getNext) {
                                  setState(() {
                                    threeErrController
                                        .reverse(); // Increase blur
                                    fourErrController
                                        .reverse(); // Increase blur
                                    sixErrController.reverse(); // Increase blur
                                    sevenErrController
                                        .reverse(); // Increase blur
                                  });

                                  setState(() {
                                    cubit.nextPlayer();
                                  });

                                  // get next player
                                }
                              },
                              child: const Text(
                                "NEXT",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 30,
                        ),
                        // if (cubit.isFullyRevealed)
                        //   SizedBox(
                        //     width: 300,
                        //     height: 40,
                        //     child: ElevatedButton(
                        //       style: ElevatedButton.styleFrom(
                        //         backgroundColor: const Color(0xFFfdeaa7),
                        //       ),
                        //       onPressed: () {
                        //         setState(() {
                        //           cubit.hideImage = !cubit.hideImage;
                        //         });
                        //       },
                        //       child: const Text(
                        //         "Hard mode",
                        //         style: TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 22,
                        //           fontWeight: FontWeight.w800,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        const SizedBox(
                          height: 150,
                        ),
                        if(screenWidth < 600)
                        InkWell(
                          onTap: () {
                            launchUrl(emailUrl, mail: true);
                          },
                          child: SizedBox(
                              height: 250,
                              width: 300,
                              child: Image.asset('assets/gif/mobilead.gif')),
                        ),
                        footerWidget(),
                      ],
                    ),
                    if (screenWidth > 800)
                      Positioned(
                        top: 20,
                        left: 20,
                        child: InkWell(
                          onTap: () {
                            launchUrl(emailUrl, mail: true);
                          },
                          child: SizedBox(
                              height: 600,
                              width: 160,
                              child: Image.asset('assets/gif/ads.gif')),
                        ),
                      ),
                    if (screenWidth > 800)
                      Positioned(
                        top: 20,
                        right: 20,
                        child: InkWell(
                          onTap: () {
                            launchUrl(emailUrl, mail: true);
                          },
                          child: SizedBox(
                              height: 600,
                              width: 160,
                              child: Image.asset('assets/gif/ads.gif')),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding footerWidget() {
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
                child: InkWell(
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
                child: InkWell(
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
                child: InkWell(
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
          Padding(
                padding: kIsWeb ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
                child: InkWell(
                  onTap: () {
                    launchUrl(buyMeAoffee);
                  },
                  child: SvgPicture.asset(
                    'assets/svgs/buymeacoffee.svg',
                    color: Colors.white,
                    height: 30,
                  ),
                ),
              ),
          const SizedBox(
            height: 12,
          ),
          const SizedBox(height: 5),
          whiteLine(width: MediaQuery.of(context).size.width * .8, height: 1),
          const SizedBox(height: 25),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: '© 2025 FIFA CARD QUIZ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.black38,
                    ),
                  ],
                ),
                children: [
                  const TextSpan(
                    text:
                        '\n\nAll logos and brands are property of their respective owners and are used for identification purposes only.',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.6, // زيادة المسافة بين الأسطر
                    ),
                  ),
                  const TextSpan(
                    text:
                        '\nThis site is not affiliated with EA Sports or FIFA in any way.',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  TextSpan(
                    text: '\n\n Power by Epic Elite',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl('https://www.instagram.com/epic.elite_?igsh=ZHE4N2x4djR0YzVj&utm_source=qr');
                      },
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent.shade100, // لون مميز ليبرز النص
                      fontSize: 16,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),
            
          ),
        ),
const SizedBox(height: 16),

          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  Widget buildAnimatedBlur(AnimationController controller, bool isRevealed,
      {required Widget child}) {
    final Animation<double> blurAnimation =
        Tween<double>(begin: 15, end: 0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    if (isRevealed) {
      controller.forward();
    } else {
      controller.reverse();
    }

    return AnimatedBuilder(
      animation: blurAnimation,
      builder: (context, _) {
        return ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: blurAnimation.value,
            sigmaY: blurAnimation.value,
          ),
          child: child,
        );
      },
    );
  }

  Widget buildAnimationBlurText(AnimationController controller, bool isRevealed,
      String text, double fontSize) {
    final Animation<double> blurAnimation =
        Tween<double>(begin: 15, end: 0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    if (isRevealed) {
      controller.forward();
    } else {
      controller.reverse();
    }
    return AnimatedBuilder(
      animation: blurAnimation,
      builder: (context, child) {
        return ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: blurAnimation.value,
            sigmaY: blurAnimation.value,
          ),
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
      },
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
                buildAnimationBlurText(
                  firstErrController,
                  cubit.isFullyRevealed || cubit.wrongAnswersCount >= 1,
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

  Widget ssbuildStatsColumn(cubit, List<Map<String, dynamic>> stats) {
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
                buildAnimationBlurText(
                  secondErrController,
                  cubit.isFullyRevealed || cubit.wrongAnswersCount >= 2,
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
                    logger.i('تم الضغط على اللاعب');
                    setState(() {
                      nameController.text =
                          '${cubit.searchedPlayers[index].firstName} ${cubit.searchedPlayers[index].lastName}';
                    });
                    onSubmit(context, player, cubit);
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

  void onSubmit(BuildContext context, PlayerModel player, BlurCubit cubit) {
    final enteredName = nameController.text.trim().toLowerCase();
    logger.i('enteredName: $enteredName');
    logger.i('matching: ${player.lastName.toLowerCase()}');

    logger.i('onSubmitssssss');
    if (formKey.currentState?.validate() ?? false) {
      if (('${player.firstName.toLowerCase()} ${player.lastName.toLowerCase()}')
          .contains(enteredName)) {
        nameController.clear();
        logger.i('right');

        // إذا كانت الإجابة صحيحة
        context.read<BlurCubit>().revealAll();
        cubit.isFullyRevealed == true;

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
        logger.e('Wrong');

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

  @override
  void dispose() {
    fourErrController.dispose();
    sixErrController.dispose();
    threeErrController.dispose();
    sevenErrController.dispose();
    secondErrController.dispose();
    fifthErrController.dispose();

    super.dispose();
  }
}

void showErrorMessage(String message, context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('خطأ'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('حسنًا'),
            onPressed: () {
              Navigator.of(context).pop(); // إغلاق نافذة التنبيه
            },
          ),
        ],
      );
    },
  );
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
