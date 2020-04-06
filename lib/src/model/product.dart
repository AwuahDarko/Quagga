class Product {
  int id;
  String name;
  String category;
  List<dynamic> image;
  double price;
  int quantity;
  int cartID;
  int index;
  int numberInStock;
  int minOrder;

  Product(
      {this.id,
      this.name,
      this.category,
      this.price,
      this.image,
      this.quantity,
      this.cartID,
      this.index,
      this.numberInStock,
      this.minOrder});
}
