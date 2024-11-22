import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  Future<Database> initDb() async {
    // Lấy đường dẫn tới thư mục lưu trữ database
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bai5.db');

    // Mở cơ sở dữ liệu và tạo bảng nếu nó chưa tồn tại
    return openDatabase(
      path,
      version: 1, // Phiên bản cơ sở dữ liệu
      onCreate: (db, version) async {
        // Tạo bảng Users
        await db.execute(
          '''CREATE TABLE Users(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              username TEXT NOT NULL, 
              password TEXT NOT NULL, 
              email TEXT NOT NULL
          )''',
        );

        // Tạo bảng Categorys
        await db.execute('''CREATE TABLE Categorys(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            logo TEXT NOT NULL
        )''');

        // Tạo bảng Products
        await db.execute('''CREATE TABLE Products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            imageUrl TEXT NOT NULL,
            price DOUBLE NOT NULL,
            description TEXT NOT NULL,
            categoryId INTEGER NOT NULL,
            FOREIGN KEY (categoryId) REFERENCES Categorys(id)
        )''');

        // Tạo bảng Carts
        await db.execute('''CREATE TABLE Carts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productId INTEGER NOT NULL,
            quantity INTEGER NOT NULL,
            userId INTEGER NOT NULL,
            FOREIGN KEY (productId) REFERENCES Products(id),
            FOREIGN KEY (userId) REFERENCES Users(id)
        )''');

        await db.execute('''CREATE TABLE Address(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER NOT NULL,
            name TEXT NOT NULL,
            country TEXT NOT NULL,
            city TEXT NOT NULL,
            phoneNumber TEXT NOT NULL,
            address TEXT NOT NULL,
            FOREIGN KEY (userId) REFERENCES Users(id)
        )''');

        await db.execute('''CREATE TABLE Orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- Mã đơn hàng
    userId INTEGER NOT NULL, -- ID người dùng
    addressId INTEGER NOT NULL, -- ID địa chỉ
    totalPrice REAL NOT NULL, -- Tổng giá trị đơn hàng
    time TEXT NOT NULL -- Thời gian đặt hàng
  )
''');

        // Thêm dữ liệu vào bảng Categorys
        await db.insert('Categorys', {
          'name': 'Electronics',
          'logo': 'assets/images/electronic.png',
        });
        await db.insert('Categorys', {
          'name': 'Clothing',
          'logo': 'assets/images/clothe.png',
        });
        await db.insert('Categorys', {
          'name': 'Home Appliances',
          'logo': 'assets/images/appliances.jpg',
        });
        await db.insert('Categorys', {
          'name': 'Sportswear',
          'logo': 'assets/images/Sportswear.png',
        });

        // Thêm dữ liệu vào bảng Products
        await db.insert('Products', {
          'name': 'Smartphone',
          'imageUrl': 'assets/images/ip15.jpg',
          'price': 599.99,
          'description': 'Latest model with high performance.',
          'categoryId': 1,
        }).then((value) => print('Inserted Smartphone: $value'));

        await db.insert('Products', {
          'name': 'T-shirt',
          'imageUrl': 'assets/images/tshirt.png',
          'price': 19.99,
          'description': 'Comfortable cotton t-shirt.',
          'categoryId': 2,
        }).then((value) => print('Inserted T-shirt: $value'));

        await db.insert('Products', {
          'name': 'Washing Machine',
          'imageUrl': 'assets/images/machine.jpg',
          'price': 350.00,
          'description': 'High-efficiency washing machine.',
          'categoryId': 3,
        }).then((value) => print('Inserted Washing Machine: $value'));

        await db.insert('Products', {
          'name': 'Running Shoes',
          'imageUrl': 'assets/images/shoes.png',
          'price': 89.99,
          'description': 'Lightweight and durable running shoes.',
          'categoryId': 4,
        }).then((value) => print('Inserted Running Shoes: $value'));

        await db.insert('Products', {
          'name': 'Laptop',
          'imageUrl': 'assets/images/laptop.jpg',
          'price': 899.99,
          'description': 'High-performance laptop for gaming and work.',
          'categoryId': 1,
        }).then((value) => print('Inserted Laptop: $value'));

        await db.insert('Products', {
          'name': 'Jacket',
          'imageUrl': 'assets/images/jacket.jpg',
          'price': 49.99,
          'description': 'Warm and stylish winter jacket.',
          'categoryId': 2,
        }).then((value) => print('Inserted Jacket: $value'));

        // Thêm dữ liệu vào bảng Users
        await db.insert('Users', {
          'username': 'admin',
          'password': 'admin123',
          'email': 'admin@example.com',
        });
      },
    );
  }
}
