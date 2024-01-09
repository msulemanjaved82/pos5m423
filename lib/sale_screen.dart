import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as Badges;
import 'cart_screen.dart';

class SaleScreen extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final Function(List<Map<String, dynamic>>)
      onSaleComplete; // Callback function

  SaleScreen({
    required this.products,
    required this.onSaleComplete,
  });

  @override
  _SaleScreenState createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  int cartItemCount = 0; // To keep track of the items in the cart
  List<Map<String, dynamic>> selectedProducts = [];
  late List<Map<String, dynamic>> filteredProducts;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    filteredProducts = List.from(widget.products);
    searchController = TextEditingController();
    searchController.addListener(searchProducts);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void decreaseAvailableQuantity(List<Map<String, dynamic>> soldProducts) {
    for (final soldProduct in soldProducts) {
      final productId =
          soldProduct['id']; // Assuming each product has an 'id' field

      // Find the sold product in the available products list and update its quantity
      final availableProductIndex =
          widget.products.indexWhere((product) => product['id'] == productId);

      if (availableProductIndex != -1) {
        setState(() {
          int availableQuantity =
              widget.products[availableProductIndex]['quantity'];
          int soldQuantity = soldProduct['quantity'];
          widget.products[availableProductIndex]['quantity'] =
              availableQuantity - soldQuantity;
        });
      }
    }
  }

  void searchProducts() {
    String searchText = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = widget.products.where((product) {
        final productName = product['name'].toString().toLowerCase();
        return productName.contains(searchText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  color: Color.fromARGB(255, 33, 246, 228),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () {
                      _addProductToSale(filteredProducts[index]);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          filteredProducts[index]['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Available: ${filteredProducts[index]['quantity']}',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Price: \$${filteredProducts[index]['price']}',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ValueListenableBuilder<int>(
        valueListenable: cartItemsNotifier,
        builder: (context, value, child) {
          return Badges.Badge(
            key: ValueKey<int>(value),
            badgeContent: Text('$value'),
            position: Badges.BadgePosition.topEnd(top: 0, end: 3),
            badgeColor: Color.fromARGB(255, 39, 240, 73),
            child: FloatingActionButton(
              onPressed: () {
                _showCartScreen(context);
              },
              child: Icon(
                Icons.shopping_cart,
                size: 40.0,
                color: Color.fromARGB(255, 98, 3, 156),
              ),
            ),
          );
        },
      ),
    );
  }

  ValueNotifier<int> cartItemsNotifier = ValueNotifier<int>(0);
  void _addProductToSale(Map<String, dynamic> product) {
    int availableQuantity = product['quantity'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedQuantity = 1; // Default quantity

        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text('Select Quantity'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Available Quantity: $availableQuantity'),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (selectedQuantity > 1) {
                              selectedQuantity--;
                            }
                          });
                        },
                        icon: Icon(Icons.remove),
                      ),
                      Text(
                        '$selectedQuantity',
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (selectedQuantity < availableQuantity) {
                              selectedQuantity++;
                            }
                          });
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Add the selected product with the chosen quantity to the cart
                    Map<String, dynamic> selectedProduct = Map.from(product);
                    selectedProduct['quantity'] = selectedQuantity;

                    // Check if the product is not already in the cart before adding
                    if (!selectedProducts.contains(selectedProduct)) {
                      selectedProducts.add(selectedProduct);

                      // Update the cart item count
                      setState(() {
                        cartItemCount = selectedProducts.length;
                        cartItemsNotifier.value =
                            cartItemCount; // Update ValueNotifier
                      });
                    }

                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('Add to Cart'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCartScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(
          selectedProducts: selectedProducts,
          removeProductFromCart: _deleteProduct,
        ),
      ),
    );
  }

  void _showCartModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected Products',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedProducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          selectedProducts[index]['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          'Price: \$${selectedProducts[index]['price']} - Quantity: ${selectedProducts[index]['quantity']}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _removeProductFromCart(index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeProductFromCart(int index) {
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
                Navigator.of(context).pop();
                _deleteProduct(index);
                _showCartModal(context); // Update the cart modal after deletion
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(int index) {
    if (index >= 0 && index < selectedProducts.length) {
      setState(() {
        selectedProducts.removeAt(index);
        cartItemCount = selectedProducts.length; // Update cart item count

        // Update the cart icon number
        cartItemsNotifier.value = cartItemCount;
      });
    } else {
      // Handle the case where the index is out of range
      print('Invalid index: $index');
    }
  }
}
