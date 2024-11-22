import 'package:bai5/database/db_helper.dart';
import 'package:bai5/models/product.dart';

class ProductDao {
  DbHelper dbHelper = DbHelper();

  Future<bool> insertProduct(Product product) async {
    final db = await dbHelper.initDb();
    int result = await db.rawInsert('''
                  INSERT INTO Products (name , price , imageUrl , description , categoryId)
                  VALUES (? , ? , ? , ? , ?)
                  ''', [
      product.name,
      product.price,
      product.imageUrl,
      product.description,
      product.categoryId
    ]);

    return result != 0;
  }

  Future<bool> updateProduct(int id, Product productUpdate) async {
    final db = await dbHelper.initDb();
    int result = await db.rawUpdate('''
                  UPDATE Products
                  SET name = ? , price = ? , imageUrl = ? , description = ? , categoryId = ?
                  WHERE id = ?
                  ''', [
      productUpdate.name,
      productUpdate.price,
      productUpdate.imageUrl,
      productUpdate.description,
      productUpdate.categoryId,
      id
    ]);

    return result != 0;
  }

  Future<bool> deleteProduct(int id) async {
    final db = await dbHelper.initDb();
    int resutl = await db.rawDelete('DELETE FROM Products WHERE id = ?', [id]);
    return resutl != 0;
  }

  Future<List<Product>> getAllListData() async {
    final db = await dbHelper.initDb();
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM Products');

    List<Product> products = result.map((p) {
      return Product(
        id: p['id'],
        name: p['name'],
        price: p['price'],
        imageUrl: p['imageUrl'],
        description: p['description'],
        categoryId: p['categoryId'],
      );
    }).toList();
    return products;
  }

  Future<List<Product>> getFindProductByCategoryId(int category_id) async {
    final db = await dbHelper.initDb();
    final List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM Products WHERE categoryId = ?', [category_id]);

    List<Product> products = result.map((p) {
      return Product(
        id: p['id'],
        name: p['name'],
        price: p['price'],
        imageUrl: p['imageUrl'],
        description: p['description'],
        categoryId: p['categoryId'],
      );
    }).toList();
    return products;
  }

  Future<List<Product>> loadMore(
      {required int page_size, required int page_number}) async {
    final db = await dbHelper.initDb();
    final List<Map<String, dynamic>> result = await db.rawQuery('''
        SELECT * FROM Products
        LIMIT ? OFFSET ?;
      ''', [page_size, (page_number - 1) * page_size]);

    List<Product> products = result.map((p) {
      return Product(
        id: p['id'],
        name: p['name'],
        price: p['price'],
        imageUrl: p['imageUrl'],
        description: p['description'],
        categoryId: p['categoryId'],
      );
    }).toList();
    return products;
  }

  Future<Product?> getAnProduct(int productId) async {
    final db = await dbHelper.initDb();
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM Products where id = ?', [productId]);

    if (result.isNotEmpty) {
      final p = result.first;
      return Product(
        id: p['id'],
        name: p['name'],
        price: p['price'],
        imageUrl: p['imageUrl'],
        description: p['description'],
        categoryId: p['categoryId'],
      );
    } else {
      return null;
    }
  }
}