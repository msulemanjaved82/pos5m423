import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Function onStartSalePressed;
  final List<Map<String, dynamic>> products;
  final Function onInventoryPressed;
  final Function onLowStockPressed;
  final Function onReportPressed;

  HomeScreen({
    required this.onStartSalePressed,
    required this.products,
    required this.onInventoryPressed,
    required this.onLowStockPressed,
    required this.onReportPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 45, bottom: 15),
          child: Container(
            width: 340,
            height: 131,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 33, 246, 228),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 40,
                  child: Icon(Icons.person,
                      color: Color.fromARGB(255, 33, 246, 228), size: 50),
                ),
                SizedBox(width: 10),
                Container(
                  height: 93,
                  width: 2,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                SizedBox(width: 10),
                Text(
                  'User Name',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 7, 107, 87),
                  ),
                ),
              ],
            ),
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          padding: EdgeInsets.all(20.0),
          shrinkWrap: true,
          children: [
            _buildCard(context, 'Start Sale', Icons.shopping_cart, () {
              onStartSalePressed(); // Calls the function to start sale
            }),
            _buildCard(context, 'Inventory', Icons.storage, () {
              onInventoryPressed(); // Navigates to Inventory Screen
            }),
            _buildCard(context, 'Reports', Icons.report, () {
              onReportPressed();
            }),
            _buildCard(context, 'Low Stock Alert', Icons.warning, () {
              onLowStockPressed();
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon,
      VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(1),
        color: Color.fromARGB(255, 33, 246, 228),
        shadowColor: Colors.grey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 70,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
