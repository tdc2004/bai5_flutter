class Cart {
  int? id;
  int productId;
  int quantity;
  int userId;

  Cart(
      { this.id,
      required this.productId,
      required this.quantity,
      required this.userId});
}