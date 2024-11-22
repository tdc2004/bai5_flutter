import 'package:bai5/dao/cart_dao.dart';
import 'package:bai5/dao/category_dao.dart';
import 'package:bai5/dao/product_dao.dart';
import 'package:bai5/models/cart.dart';
import 'package:bai5/models/category.dart';
import 'package:bai5/models/product.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> listAllProduct = [];
  List<Category> listAllcate = [];
  ProductDao productDao = ProductDao();
  CartDao cartDao = CartDao();
  CategoryDao cateDao = CategoryDao();

  @override
  void initState() {
    super.initState();
    loadProductData();
  }

  Future<void> loadProductData() async {
    List<Product> list = await productDao.getAllListData();
    List<Category> listCate = await cateDao.getAllListData();
    setState(() {
      listAllProduct = list;
      listAllcate = listCate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sản phẩm"),
      ),
      body: listAllProduct.isEmpty
          ? const Center(
              child: Text(
                'Không có sản phẩm nào!',
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
              itemCount: listAllProduct.length,
              itemBuilder: (context, index) {
                final product = listAllProduct[index];
                return GestureDetector(
                  onTap: () {
                    showProductDetails(product.id);
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
                            product.imageUrl,
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
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.green),
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

  void showProductDetails(int productId) async {
    // Lấy sản phẩm theo id từ cơ sở dữ liệu
    Product? product = await productDao.getAnProduct(productId);
    Category? category = await cateDao.getAnCategory(productId);

    if (product == null) {
      // Nếu không tìm thấy sản phẩm, hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tìm thấy sản phẩm!')),
      );
      return;
    }

    int quantity = 1; // Khởi tạo số lượng mặc định là 1

    // Hiển thị hộp thoại chi tiết sản phẩm
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // Thêm StatefulBuilder để cập nhật giao diện
          builder: (context, setState) {
            return AlertDialog(
              title: Text(product.name),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    product.imageUrl.isNotEmpty
                        ? Image.asset(
                            product.imageUrl,
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported,
                                  size: 100);
                            },
                          )
                        : const Icon(Icons.image_not_supported, size: 100),
                    const SizedBox(height: 10),
                    Text(
                      'Giá: \$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Mô tả: ${product.description}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Thể Loại: ${category?.name}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    // Thêm nút tăng và giảm số lượng
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (quantity > 1) quantity--; // Giảm số lượng
                            });
                          },
                        ),
                        Text(
                          '$quantity',
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantity++; // Tăng số lượng
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                // Nút "Thêm vào giỏ hàng"
                TextButton(
                  onPressed: () {
                    // Xử lý thêm sản phẩm vào giỏ hàng với số lượng được điều chỉnh
                    addToCart(product, quantity);
                    Navigator.pop(context);
                  },
                  child: const Text('Add To Cart'),
                ),
                // Nút "Đóng"
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void addToCart(Product product, int quantity) async {
    Cart cart = Cart(
      productId: product.id, // ID của sản phẩm
      quantity: quantity, // Số lượng sản phẩm (thêm 1)
      userId: 1, // ID người dùng, có thể thay bằng ID người dùng thật
    );
    bool check = await cartDao.insertCart(cart);
    if (check) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} đã được thêm vào giỏ hàng!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi thêm sản phẩm vào giỏ hàng!')),
      );
    }
  }
}
