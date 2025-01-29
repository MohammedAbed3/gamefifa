import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorPage({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              SvgPicture.asset(
                      'assets/svgs/errorpage.svg',
                    ),
          
              const SizedBox(height: 20),
          
              // Error Message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
          
              const SizedBox(height: 30),
          
              // Retry Button
          ElevatedButton.icon(
            onPressed: () {
              onRetry();
        
            },
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
          
            ],
          ),
        ),
      ),
    );
  }
}
