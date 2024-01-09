import 'package:flutter/material.dart';
import 'receipt.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedProducts;
  final Function(int) removeProductFromCart;

  CartScreen({
    required this.selectedProducts,
    required this.removeProductFromCart,
  });

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int cartItemCount = 0;
  double _calculateSubTotal() {
    double subTotal = 0.0;

    // Calculate sub-total
    widget.selectedProducts.forEach((product) {
      dynamic price = product['price'];
      dynamic quantity = product['quantity'];

      if (price is num && quantity is int) {
        subTotal += price * quantity;
      }
    });

    return subTotal;
  }

  double _calculateNetAmount(double subTotal, double discount) {
    return subTotal - discount;
  }

  double _discount = 0.0;
  late TextEditingController _discountController;

  @override
  void initState() {
    super.initState();
    _discountController = TextEditingController();
    updateCartItemCount();
  }

  void updateCartItemCount() {
    setState(() {
      cartItemCount = widget.selectedProducts.length;
    });
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  void _confirmDeletion(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to remove this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.removeProductFromCart(index);
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  // Update the state to reflect the changes after deletion
                  // This will rebuild the widget, and the deleted item will disappear
                });
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double subTotal = _calculateSubTotal();
    double netAmount = _calculateNetAmount(subTotal, _discount);
    int totalProducts =
        widget.selectedProducts.length; // Total number of products

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 11, 111, 81),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Cart',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Text(
                  'Total Products: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                Text(
                  '$totalProducts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        color: Color(0xFF0DBB87),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.selectedProducts.isEmpty)
              Spacer(), // Pushes content to the bottom if no products selected
            widget.selectedProducts.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 8.0),
                    child: Text(
                      'Empty Cart',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: widget.selectedProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        dynamic price = widget.selectedProducts[index]['price'];
                        dynamic quantity =
                            widget.selectedProducts[index]['quantity'];

                        double totalPrice = 0.0;

                        if (price is double && quantity is int) {
                          totalPrice = price * quantity;
                        } else if (price is int && quantity is int) {
                          totalPrice = price.toDouble() * quantity;
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 20.0,
                          ),
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            color: Colors.blue[100],
                            child: ListTile(
                              title: Text(
                                widget.selectedProducts[index]['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Price: \$${price.toString()} - Quantity: ${quantity.toString()}',
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  _confirmDeletion(index);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            Container(
              color: Colors.blue.shade200,
              padding: EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sub Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                      Text(
                        '\$${subTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Discount:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        width: 65,
                        height: 40,
                        padding: const EdgeInsets.only(left: 15.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 19, 76, 181),
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(31, 255, 250, 250),
                              offset: Offset(0, 1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _discountController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 16),
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                _discount = double.tryParse(value) ?? 0.0;
                              } else {
                                _discount = 0.0;
                              }
                              netAmount =
                                  _calculateNetAmount(subTotal, _discount);
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                            ), // Adjust padding
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Net Amount:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '\$${netAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Create the receipt widget instance
                      ReceiptWidget receiptWidget = ReceiptWidget(
                        receiptNumber: 12345678,
                        totalProducts: totalProducts,
                        subTotal: subTotal,
                        discount: _discount,
                        netAmount: netAmount,
                        products: List<Map<String, dynamic>>.from(widget
                            .selectedProducts), // Pass a copy of the products
                      );

                      // Navigate to the receipt screen and pass the receipt widget instance
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => receiptWidget,
                        ),
                      ).then((value) {
                        // Clear the selected products list after returning from the ReceiptWidget screen
                        setState(() {
                          widget.selectedProducts.clear();
                          cartItemCount = 0;
                        });
                      });
                    },
                    child: Text(
                      'Generate Receipt',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 98, 3, 156),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
