import 'package:bai5/database/db_helper.dart';
import 'package:bai5/models/address.dart';

class AddressDao {
  DbHelper dbHelper = DbHelper();

  Future<bool> insertAddress(Address address) async {
    final db = await dbHelper.initDb(); //Khởi tạo db

    int result = await db.rawInsert('''
                  INSERT INTO Address (userId ,name , country, city , phoneNumber,address)
                  VALUES (? , ? , ? , ? , ? , ?)
                  ''', [
      address.userId,
      address.name,
      address.country,
      address.city,
      address.phoneNumber,
      address.address
    ]);

    return result != 0;
  }

  Future<List<Address>> getAllListData() async {
    final db = await dbHelper.initDb(); //Khởi tạo db
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM Address');
    List<Address> address = result.map((record) {
      return Address(
        id: record['id'],
        userId: record['userId'],
        name: record['name'],
        country: record['country'],
        city: record['city'],
        phoneNumber: record['phoneNumber'],
        address: record['address'],
      );
    }).toList();
    return address;
  }
}