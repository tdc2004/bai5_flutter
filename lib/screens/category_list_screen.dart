import 'package:bai5/dao/category_dao.dart';
import 'package:bai5/models/category.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Category> listAllCategory = [];
  CategoryDao categoryDao = CategoryDao();

  @override
  void initState() {
    super.initState();
    loadCategoryData();
  }

  Future<void> loadCategoryData() async {
    List<Category> list = await categoryDao.getAllListData(); // Lấy danh mục từ DB
    setState(() {
      listAllCategory = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thể Loại"),
      ),
      body: listAllCategory.isEmpty
          ? const Center(
              child: Text(
                'Không có thể loại nào!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Số item trong một hàng
                crossAxisSpacing: 8, // Khoảng cách giữa các cột
                mainAxisSpacing: 8, // Khoảng cách giữa các hàng
                childAspectRatio: 0.75, // Tỷ lệ chiều rộng/chiều cao của item
              ),
              itemCount: listAllCategory.length,
              itemBuilder: (context, index) {
                final category = listAllCategory[index];
                return GestureDetector(
                  onTap: () {
                    // Xử lý khi nhấn vào danh mục
                    // Bạn có thể chuyển sang màn hình sản phẩm của danh mục ở đây
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.asset(
                            category.logo,  // Hiển thị logo của danh mục
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            category.name,  // Tên danh mục
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
