import 'package:bai5/dao/order_dao.dart';
import 'package:bai5/models/order.dart';
import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final OrderDao orderDao = OrderDao();
  List<Order> orderList = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  _loadOrders() async {
    final userId = 1; 
    final orders = await orderDao.getAllListData(userId);
    setState(() {
      orderList = orders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử đơn hàng'),
      ),
      body: ListView.builder(
        itemCount: orderList.length,
        itemBuilder: (context, index) {
          Order order = orderList[index];
          return Card(
            child: ListTile(
              title: Text('Mã đơn hàng: ${order.id}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Địa chỉ: ${order.addressId}'),
                  Text('Tổng giá trị: ${order.totalPrice}'),
                  Text('Ngày đặt: ${order.time != null ? DateTime.parse(order.time).toLocal() : 'Chưa có thời gian'}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
