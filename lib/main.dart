import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'my_inventory_app.dart';

void main() {
  runApp(MyApp());
  // Delay the navigation to MyInventoryApp after 2 seconds
  Future.delayed(Duration(seconds: 2), () {
    runApp(MyInventoryApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
