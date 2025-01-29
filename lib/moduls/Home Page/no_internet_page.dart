import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fifa_card_quiz/moduls/Home%20Page/home_page.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});

  @override
  _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  bool _isConnected = true;
  bool _isChecking = false;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    print('initState called');
    _checkConnectivity();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      if (!mounted) return; // التأكد من أن الـ State ما زال mounted
      print('Connectivity changed: $result');
      final isConnectedNow = result != ConnectivityResult.none;
      setState(() {
        _isConnected = isConnectedNow;
      });

      if (isConnectedNow) {
        print('Internet connected, navigating to HomePage...');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false,
            );
          }
        });
      } else {
        print('No internet connection');
      }
    }) as StreamSubscription<ConnectivityResult>;
  }

  @override
  void dispose() {
    _connectivitySubscription
        .cancel(); // إلغاء الاشتراك عند التخلص من الـ Widget
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    if (_isChecking) return;
    _isChecking = true;

    try {
      print('Checking initial connectivity...');
      final initialConnectivity = await Connectivity().checkConnectivity();
      print('Initial connectivity: $initialConnectivity');
      if (!mounted) return;
      setState(() {
        _isConnected = initialConnectivity != ConnectivityResult.none;
      });
    } catch (e) {
      print('Error checking connectivity: $e');
      if (!mounted) return;
      setState(() {
        _isConnected = false; // افترض عدم وجود اتصال في حالة الخطأ
      });
    } finally {
      _isChecking = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building UI...');
    if (!_isConnected) {
      print('No internet connection, showing NoInternetPage');
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
    print('Connected, showing loading indicator');
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
