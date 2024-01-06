import 'package:flutter/material.dart';

class InventoryListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function onInventoryPressed;

  InventoryListScreen({
    required this.products,
    required this.onInventoryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          color: Color.fromARGB(255, 33, 246, 228),
          child: ListTile(
            title: Text(products[index]['name']),
            subtitle: Text(
              'Price: \$${products[index]['price']} - Quantity: ${products[index]['quantity']}',
            ),
            onTap: () {
              onInventoryPressed(); // Navigates to Inventory Screen
            },
          ),
        );
      },
    );
  }
}
