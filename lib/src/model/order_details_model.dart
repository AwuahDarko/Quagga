class OrderDetailsModel {
  String productName;
  String image;
  double price;
  int quantity;
  int orderID;
  String orderKey;
  String status;

  OrderDetailsModel({this.image, this.status, this.price, this.quantity,
      this.orderID, this.orderKey, this.productName});
}
