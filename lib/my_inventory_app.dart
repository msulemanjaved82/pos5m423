import 'package:flutter/material.dart';
import 'inventory_screen.dart';

class MyInventoryApp extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Product 1',
      'price': 20.0,
      'quantity': 10,
    },
    {
      'name': 'Product 2',
      'price': 30.0,
      'quantity': 15,
    },
    // Add more product details as needed
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF0DBB87),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: InventoryScreen(products: products),
    );
  }
}
