import 'package:bai5/database/db_helper.dart';
import 'package:bai5/models/order.dart';

class OrderDao {
  DbHelper dbHelper = DbHelper();

  // Thêm đơn hàng vào cơ sở dữ liệu
  Future<int> insertOrder(Order order) async {
    final db = await dbHelper.initDb(); // Khởi tạo db
   
    int result = await db.rawInsert('''
    INSERT INTO Orders (userId, addressId, totalPrice, time)
    VALUES (?, ?, ?, ?)
  ''', [order.userId, order.addressId, order.totalPrice, order.time]);

    return result; // Trả về ID của đơn hàng vừa chèn vào
  }

  // Lấy tất cả đơn hàng của người dùng theo userId
  Future<List<Order>> getAllListData(int userId) async {
    final db = await dbHelper.initDb();
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM Orders WHERE userId = ?', [userId]);

    List<Order> orders = result.map((o) {
      return Order(
        id: o['id'],
        userId: o['userId'],
        addressId: o['addressId'],
        totalPrice: o['totalPrice'],
        time: o['time'],
      );
    }).toList();

    return orders;
  }
}
