class Order {
  int? id;
  int userId;
  int addressId;
  double totalPrice;
  String time;

  Order({
     this.id,
    required this.userId,
    required this.addressId,
    required this.totalPrice,
    required this.time,
  });
}
