import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fifa_card_quiz/moduls/Home%20Page/home_page.dart';
import 'package:logger/logger.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({Key? key}) : super(key: key);

  @override
  _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  bool _isConnected = true;
  bool _isChecking = false;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    logger.i('initState called');
    _checkConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (!mounted) return; // بنتأكد إن الـ widget بعدها موجودة
      logger.i('Connectivity changed: $result');
      final isConnectedNow = result.isNotEmpty && result.first != ConnectivityResult.none;
      setState(() {
        _isConnected = isConnectedNow;
      });

      if (isConnectedNow) {
        logger.i('Internet connected, navigating to HomePage...');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false,
            );
          }
        });
      } else {
        logger.e('No internet connection');
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel(); // بنلغي الاشتراك عند التخلص من الـ widget
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    if (_isChecking) return;
    _isChecking = true;

    try {
      logger.i('Checking initial connectivity...');
      final initialConnectivity = await Connectivity().checkConnectivity();
      logger.i('Initial connectivity: $initialConnectivity');
      if (!mounted) return;
      setState(() {
        _isConnected = initialConnectivity != ConnectivityResult.none;
      });
    } catch (e) {
      logger.e('Error checking connectivity: $e');
      if (!mounted) return;
      setState(() {
        _isConnected = false; // بنفترض عدم وجود اتصال في حالة الخطأ
      });
    } finally {
      _isChecking = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.i('Building UI...');
    if (!_isConnected) {
      logger.e('No internet connection, showing NoInternetPage');
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 100, color: Colors.red),
              const SizedBox(height: 20),
              const Text(
                'لا يوجد اتصال بالإنترنت',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkConnectivity,
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    // عرض واجهة انتظار مؤقتة حتى يتم التنقل للصفحة الرئيسية
    logger.i('Connected, showing loading indicator');
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
