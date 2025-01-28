import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:guess_the_player/moduls/Home%20Page/home_page.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});

  @override
  _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    print('initState called');
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    print('Checking initial connectivity...');
    final initialConnectivity = await Connectivity().checkConnectivity();
    print('Initial connectivity: $initialConnectivity');
    setState(() {
      _isConnected = initialConnectivity != ConnectivityResult.none;
    });

    // مراقبة التغييرات بحالة الإنترنت
    Connectivity().onConnectivityChanged.listen((result) {
      print('Connectivity changed: $result');
      final isConnectedNow = result != ConnectivityResult.none;
      setState(() {
        _isConnected = isConnectedNow;
      });

      // إذا تم الاتصال بالإنترنت، قم بالتنقل للـ HomePage
      if (isConnectedNow) {
        print('Internet connected, navigating to HomePage...');
        
        // استخدام addPostFrameCallback لضمان الانتقال بعد بناء الواجهة
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false,  // This will remove all previous routes
            );
          }
        });
      } else {
        print('No internet connection');
      }
    });
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
