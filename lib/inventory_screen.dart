import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'inventory_list_screen.dart';
import 'sale_screen.dart';
import 'report.dart';
import 'add_product_screen.dart';
import 'stockalert.dart';

class InventoryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  InventoryScreen({required this.products});

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  int _selectedIndex = 0;
  String _searchText = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getScreenTitle(_selectedIndex),
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 11, 111, 81),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _selectedIndex == 1
              ? Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
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
                    onChanged: (value) {
                      setState(() {
                        _searchText = value.toLowerCase();
                      });
                    },
                  ),
                )
              : SizedBox(),
          Expanded(
            child: _getSelectedScreen(_selectedIndex),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 11, 111, 81),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, size: 35.0),
              onPressed: () => _onItemTapped(0),
              color: _selectedIndex == 0
                  ? Color.fromARGB(255, 255, 255, 255)
                  : Colors.black,
            ),
            IconButton(
              icon: Icon(
                Icons.add_shopping_cart,
                size: 35.0,
              ),
              onPressed: () => _onItemTapped(2),
              color: _selectedIndex == 2
                  ? Color.fromARGB(255, 255, 255, 255)
                  : Colors.black,
            ),
            IconButton(
              icon: Icon(Icons.inventory, size: 35.0),
              onPressed: () => _onItemTapped(1),
              color: _selectedIndex == 1
                  ? Color.fromARGB(255, 255, 255, 255)
                  : Colors.black,
            ),
            IconButton(
              icon: Icon(Icons.report, size: 40.0),
              onPressed: () => _onItemTapped(3),
              color: _selectedIndex == 3
                  ? Color.fromARGB(255, 255, 255, 255)
                  : Colors.black,
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () async {
                final Map<String, dynamic>? newProduct =
                    await navigateToAddProductScreen(context);

                if (newProduct != null) {
                  // Check if the product already exists
                  bool productExists = widget.products.any((product) =>
                      product['name'] == newProduct['name'] &&
                      product['price'] == newProduct['price'] &&
                      product['quantity'] == newProduct['quantity']);

                  if (!productExists) {
                    _addProduct(newProduct);
                  }
                }
              },
              backgroundColor: Color.fromARGB(255, 82, 237, 65),
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  Future<Map<String, dynamic>?> navigateToAddProductScreen(
      BuildContext context) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductScreen(onProductAdded: _addProduct),
      ),
    );
  }

  // Inside _InventoryScreenState

  void _increaseQuantity(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int quantityToAdd = 1; // Default quantity to add
        return AlertDialog(
          title: Text('Increase Quantity'),
          content: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter quantity to add'),
            onChanged: (value) {
              quantityToAdd = int.tryParse(value) ?? 1;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  widget.products[index]['quantity'] += quantityToAdd;
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _updateInventory(List<Map<String, dynamic>> updatedProducts) {
    setState(() {
      // Update inventory quantities
      for (var updatedProduct in updatedProducts) {
        int existingProductIndex = widget.products.indexWhere(
          (product) => product['id'] == updatedProduct['id'],
        );

        if (existingProductIndex != -1) {
          // Reduce the quantity in inventory
          widget.products[existingProductIndex]['quantity'] -=
              updatedProduct['quantity'];
        }
      }
    });
  }

  void _addProduct(Map<String, dynamic> newProduct) {
    setState(() {
      // Check if the product already exists by its name
      int existingProductIndex = widget.products.indexWhere(
        (product) => product['name'] == newProduct['name'],
      );

      int quantityToAdd = newProduct['quantity'] ??
          0; // Default quantity to add if not provided

      if (quantityToAdd > 0) {
        if (existingProductIndex != -1) {
          // Product already exists, update the quantity
          widget.products[existingProductIndex]['quantity'] += quantityToAdd;
        } else {
          // Product doesn't exist, add it to the list
          newProduct['quantity'] = quantityToAdd;
          widget.products.add(newProduct);
        }
      }
    });
  }

  Widget _getSelectedScreen(int index) {
    switch (index) {
      case 0:
        return HomeScreen(
          onStartSalePressed: () {
            _onItemTapped(2);
          },
          products: widget.products,
          onInventoryPressed: () {
            _onItemTapped(1);
          },
          onLowStockPressed: () {
            _onItemTapped(4);
          },
          onReportPressed: () {
            _onItemTapped(3);
          },
        );

      case 1:
        final filteredProducts = _filterProducts();
        return InventoryListScreen(
          products: filteredProducts,
          onInventoryPressed: () {
            _onItemTapped(1);
          },
          onQuantityIncreased: _increaseQuantity,
        );
      case 2:
        return SaleScreen(
          products: widget.products,
          onSaleComplete: _updateInventory,
        );
      case 3:
        return ReportScreen();
      case 4:
        return LowStockAlertScreen();
      default:
        return Container();
    }
  }

  String _getScreenTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Inventory';
      case 2:
        return 'Sale';
      case 3:
        return 'SalesReports';
      case 4:
        return 'Low Stock Alert';
      default:
        return '';
    }
  }

  List<Map<String, dynamic>> _filterProducts() {
    return widget.products.where((product) {
      final productName = product['name'].toString().toLowerCase();
      return productName.contains(_searchText);
    }).toList();
  }
}
