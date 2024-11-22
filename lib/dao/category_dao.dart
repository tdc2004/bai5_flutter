import 'package:bai5/database/db_helper.dart';
import 'package:bai5/models/category.dart';

class CategoryDao {
  DbHelper dbHelper = DbHelper();

  Future<bool> insertCategory(Category category) async {
    final db = await dbHelper.initDb(); //Khởi tạo db

    int result = await db.rawInsert('''
                  INSERT INTO Categorys (name , logo)
                  VALUES (? , ?)
                  ''', [category.name, category.logo]);

    return result != 0;
  }

  Future<bool> updateCategory(int id, Category category) async {
    final db = await dbHelper.initDb();

    int result = await db.rawUpdate('''
        UPDATE Categorys
        SET name = ?, logo = ?
        WHERE id = ?
        ''', [category.name, category.logo, id]);

    return result > 0;
  }

  Future<bool> deleteCategory(int id) async {
    final db = await dbHelper.initDb();
    int result = await db.rawDelete('DELETE FROM Categorys WHERE id = ?', [id]);
    return result != 0;
  }

  Future<List<Category>> getAllListData() async {
    final db = await dbHelper.initDb();
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM Categorys');

    List<Category> categories = result.map((record) {
      return Category(
        id: record['id'],
        name: record['name'],
        logo: record['logo'],
      );
    }).toList();
    return categories;
  }

  Future<Category?> getAnCategory(int productId) async {
    final db = await dbHelper.initDb();
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM Categorys WHERE id = ?', [productId]);

    if (result.isNotEmpty) {
      // Lấy bản ghi đầu tiên trong kết quả trả về
      final record = result.first;
      Category category = Category(
        id: record['id'],
        name: record['name'],
        logo: record['logo'],
      );
      return category; // Return Category
    } else {
      return null; // Return không tìm thấy kết quả
    }
  }
}