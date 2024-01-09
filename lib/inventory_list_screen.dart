import 'package:flutter/material.dart';

class InventoryListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function onInventoryPressed;
  final Function(int) onQuantityIncreased;

  InventoryListScreen({
    required this.products,
    required this.onInventoryPressed,
    required this.onQuantityIncreased,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.white, // Set your desired card color here
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            title: Text(
              products[index]['name'],
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Set your desired text color here
              ),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price: \$${products[index]['price']}',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: const Color.fromARGB(
                        255, 0, 0, 0), // Set your desired text color here
                  ),
                ),
                Text(
                  'Quantity: ${products[index]['quantity']}',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color.fromARGB(
                        255, 0, 0, 0), // Set your desired text color here
                  ),
                ),
              ],
            ),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Set your desired button color here
              ),
              onPressed: () {
                onQuantityIncreased(index);
              },
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white, // Set your desired text color here
                ),
              ),
            ),
            onTap: () {
              onInventoryPressed();
            },
          ),
        );
      },
    );
  }
}
