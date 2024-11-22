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
  // ignore: library_private_types_in_public_api
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartDao cartdao = CartDao();
  List<Cart> cartList = [];
  List<Product> proList = [];
  List<Address> addressList = [];
  ProductDao productDao = ProductDao();
  AddressDao addressDao = AddressDao();

  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  // Hàm tải danh sách giỏ hàng từ cơ sở dữ liệu
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

  // Hàm cập nhật số lượng sản phẩm trong giỏ hàng
  _updateQuantity(int cartId, int quantity) async {
    bool success = await cartdao.updateCart(cartId, quantity);
    if (success) {
      _loadCartData();
    }
  }

  // Hàm xóa sản phẩm khỏi giỏ hàng
  _deleteCartItem(int cartId) async {
    bool success = await cartdao.deleteCart(cartId);
    if (success) {
      _loadCartData();
    }
  }

  // Hàm tính tổng giá trị đơn hàng
  double _calculateTotalPrice() {
    double totalPrice = 0.0;
    for (int i = 0; i < cartList.length; i++) {
      Cart cart = cartList[i];
      Product product = proList.firstWhere((prod) =>
          prod.id == cart.productId); // Lấy sản phẩm từ proList theo productId
      totalPrice += cart.quantity *
          product.price; // Tính tổng giá trị của sản phẩm trong giỏ hàng
    }
    return totalPrice;
  }

  int _calculateTotalQuantity() {
    int totalQuantity = 0;
    for (var cart in cartList) {
      totalQuantity +=
          cart.quantity; // Cộng dồn số lượng của mỗi sản phẩm trong giỏ
    }
    return totalQuantity;
  }

  // Hàm xử lý Checkout
  void _handleCheckout() async {
    if (cartList.isEmpty) {
      // Nếu giỏ hàng trống, hiển thị thông báo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giỏ hàng của bạn hiện tại đang trống!')),
      );
      return;
    }

    // Kiểm tra nếu người dùng chưa chọn địa chỉ giao hàng
    if (addressList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần chọn địa chỉ giao hàng!')),
      );
      return;
    }

    // Tính tổng giá trị đơn hàng
    double totalPrice = _calculateTotalPrice();

    // Tạo đơn hàng mới từ giỏ hàng và địa chỉ giao hàng
    Order newOrder = Order(
      userId:
          1, // Giả sử userId là 1, thay thế bằng ID người dùng thực tế nếu có
      addressId:
          addressList[0].id, // Lấy ID của địa chỉ giao hàng từ addressList
      totalPrice: _calculateTotalPrice(), // Tổng giá trị đơn hàng
      time: DateTime.now().toString(), // Ngày đặt hàng (chuyển đổi thành chuỗi)
    );

    // Lưu đơn hàng vào cơ sở dữ liệu
    OrderDao orderDao = OrderDao();
    int orderId = await orderDao.insertOrder(newOrder);

    // Thông báo đơn hàng đã được đặt
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đặt hàng thành công, mã đơn hàng: $orderId')),
    );

    // Làm trống giỏ hàng sau khi đặt hàng thành công
    setState(() {
      cartList.clear();
    });

    // Có thể chuyển người dùng sang màn hình đơn hàng đã đặt, hoặc quay lại trang chủ
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
          // ListView chiếm 60% chiều cao màn hình
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
                          ? "Địa chỉ: ${addressList[0].address}" // Hiển thị địa chỉ đầu tiên trong danh sách
                          : "Địa chỉ: Chưa chọn", // Nếu không có địa chỉ, hiển thị thông báo
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      // Chuyển sang màn hình AddressScreen và đợi kết quả trả về
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

                  Text(
                      'Tổng giá trị: ${_calculateTotalPrice()}'), // Hiển thị tổng giá trị
                ],
              ),
            ),
          ),
          // Card: Select Address

          // Nút Checkout cố định ở cuối màn hình
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _handleCheckout,
              // ignore: sort_child_properties_last
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
