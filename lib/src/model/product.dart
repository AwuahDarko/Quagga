import 'package:quagga/src/model/sub_product.dart';

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
  String description;
  List<SubProduct> subProducts;
  String type;
  int favoriteID;
  int categoryID;

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
      this.minOrder,
      this.description,
      this.subProducts,
      this.type,
      this.favoriteID,
      this.categoryID});
}
