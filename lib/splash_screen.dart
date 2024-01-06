import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0DBB87),
      body: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}
