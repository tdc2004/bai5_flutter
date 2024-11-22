import 'package:bai5/screens/category_list_screen.dart';
import 'package:bai5/screens/login_screen.dart';
import 'package:bai5/screens/order_history_screen.dart';
import 'package:bai5/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:bai5/screens/cart_screen.dart';
import 'package:bai5/screens/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WelcomeScreen(), 
    );
  }
}

class NavigatorApp extends StatefulWidget {
  const NavigatorApp({super.key});

  @override
  State<NavigatorApp> createState() => _NavigatorAppState();
}

class _NavigatorAppState extends State<NavigatorApp> {
  int _selectedIndex = 0;

  // Danh sách các màn hình tương ứng với các tab
  static List<Widget> _widgetOptions = <Widget>[
    ProductScreen(),
    CategoryScreen(), // Màn hình danh mục
    CartScreen(), // Màn hình giỏ hàng
    OrderHistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật màn hình được chọn
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NavigatorApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex), // Hiển thị màn hình tương ứng
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag), label: 'Products'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'Category'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Cart'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'Order'),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 5.0,
          onTap: _onItemTapped, // Xử lý khi người dùng chọn tab
        ),
      ),
    );
  }
}
