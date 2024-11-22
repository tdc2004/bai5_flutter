import 'package:bai5/dao/address_dao.dart';
import 'package:bai5/dao/cart_dao.dart';
import 'package:bai5/dao/order_dao.dart';
import 'package:bai5/dao/product_dao.dart';
import 'package:bai5/models/address.dart';
import 'package:bai5/models/cart.dart';
import 'package:bai5/models/order.dart';
import 'package:bai5/models/product.dart';
import 'package:bai5/screens/address_screen.dart';
import 'package:bai5/screens/order_history_screen.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartDao cartdao = CartDao();
  List<Cart> cartList = [];
  List<Product> proList = [];
  List<Address> addressList = [];
  final ProductDao productDao = ProductDao();
  final AddressDao addressDao = AddressDao();

  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  _loadCartData() async {
    final cartItems = await cartdao.getAllListData();
    final proItems = await productDao.getAllListData();
    final addressItems = await addressDao.getAllListData();
    setState(() {
      cartList = cartItems;
      proList = proItems;
      addressList = addressItems;
    });
  }

  _updateQuantity(int cartId, int quantity) async {
    bool success = await cartdao.updateCart(cartId, quantity);
    if (success) {
      _loadCartData();
    }
  }

  _deleteCartItem(int cartId) async {
    bool success = await cartdao.deleteCart(cartId);
    if (success) {
      _loadCartData();
    }
  }

  double _calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var cart in cartList) {
      var product = proList.firstWhere((prod) => prod.id == cart.productId);
      totalPrice += cart.quantity * product.price;
    }
    return totalPrice;
  }

  int _calculateTotalQuantity() {
    int totalQuantity = 0;
    for (var cart in cartList) {
      totalQuantity += cart.quantity;
    }
    return totalQuantity;
  }

  void _handleCheckout() async {
    if (cartList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giỏ hàng của bạn hiện tại đang trống!')),
      );
      return;
    }

    if (addressList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần chọn địa chỉ giao hàng!')),
      );
      return;
    }

    Order newOrder = Order(
      userId: 1,
      addressId: addressList[0].id,
      totalPrice: _calculateTotalPrice(),
      time: DateTime.now().toString(),
    );

    OrderDao orderDao = OrderDao();
    int orderId = await orderDao.insertOrder(newOrder);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đặt hàng thành công, mã đơn hàng: $orderId')),
    );

    setState(() {
      cartList.clear();
    });

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ Hàng'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: cartList.isEmpty
                ? const Center(child: Text('Giỏ hàng của bạn đang trống'))
                : ListView.builder(
                    itemCount: cartList.length,
                    itemBuilder: (context, index) {
                      Cart cart = cartList[index];
                      Product product = proList
                          .firstWhere((prod) => prod.id == cart.productId);
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: product.imageUrl.isNotEmpty
                              ? Image.asset(
                                  product.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                )
                              : const Icon(Icons.image_not_supported, size: 50),
                          title: Text('Tên sản phẩm: ${product.name}'),
                          subtitle: Row(
                            children: [
                              Text('Số lượng: ${cart.quantity}'),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (cart.quantity > 1) {
                                    _updateQuantity(
                                        cart.id!, cart.quantity - 1);
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  _updateQuantity(cart.id!, cart.quantity + 1);
                                },
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteCartItem(cart.id!);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Card(
            margin: const EdgeInsets.all(10),
            elevation: 0,
            child: ListTile(
              title: const Text('Chọn địa chỉ giao hàng'),
              subtitle: Row(
                children: [
                  Expanded(
                    child: Text(
                      addressList.isNotEmpty
                          ? "Địa chỉ: ${addressList[0].address}"
                          : "Địa chỉ: Chưa chọn",
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddAddressScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(10),
            elevation: 0,
            child: ListTile(
              title: const Text('Thông tin đơn hàng'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tổng số lượng sản phẩm: ${_calculateTotalQuantity()}'),
                  Text('Tổng giá trị: ${_calculateTotalPrice()}'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _handleCheckout,
              child: const Text(
                'Checkout',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(size.width * 0.9, 48),
                  backgroundColor: const Color(0xff4A4E69),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6))),
            ),
          ),
        ],
      ),
    );
  }
}
