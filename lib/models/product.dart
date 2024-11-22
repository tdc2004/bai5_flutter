class Product {
  int id;
  String name;
  double price;
  String imageUrl;
  String description;
  int categoryId;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.imageUrl,
      required this.description,
      required this.categoryId});
}