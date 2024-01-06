import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'inventory_list_screen.dart';
import 'sale_screen.dart';
import 'watchlist_screen.dart';
import 'add_product_screen.dart';

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
        backgroundColor: Color(0xFF2BD6A3),
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
        color: Color(0xFF2BD6A3),
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
                Icons.inventory,
                size: 35.0,
              ),
              onPressed: () => _onItemTapped(1),
              color: _selectedIndex == 1
                  ? Color.fromARGB(255, 255, 255, 255)
                  : Colors.black,
            ),
            IconButton(
              icon: Icon(Icons.add_shopping_cart, size: 35.0),
              onPressed: () => _onItemTapped(2),
              color: _selectedIndex == 2
                  ? Color.fromARGB(255, 255, 255, 255)
                  : Colors.black,
            ),
            IconButton(
              icon: Icon(Icons.watch_later, size: 35.0),
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
              backgroundColor: Color.fromARGB(255, 246, 208, 37),
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

  void _addProduct(Map<String, dynamic> newProduct) {
    setState(() {
      bool productExists = widget.products.any((product) =>
          product['name'] == newProduct['name'] &&
          product['price'] == newProduct['price'] &&
          product['quantity'] == newProduct['quantity']);

      if (!productExists) {
        widget.products.add(newProduct);
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
        );
      case 1:
        final filteredProducts = _filterProducts();
        return InventoryListScreen(
          products: filteredProducts,
          onInventoryPressed: () {
            _onItemTapped(1);
          },
        );
      case 2:
        return SaleScreen();
      case 3:
        return WatchlistScreen();
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
        return 'Watchlist';
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
