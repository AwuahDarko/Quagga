import 'dart:convert';

import 'package:quagga/src/model/product.dart';
import 'package:quagga/src/model/category.dart';
import 'package:quagga/src/model/sub_product.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:http/http.dart' as http;

class AppData {
  static List<Product> productList = [];

  static List<Product> cartList = [];
  static List<Category> categoryList = [];
  static List<String> showThumbnailList = [
    "http://placekitten.com/90/60",
    "http://placekitten.com/90/60",
    "http://placekitten.com/90/60",
    "http://placekitten.com/90/60",
  ];
  static String description =
      "The Most Extensive Range of First Aid Kit available in a single Kit. Known for their transparent packaging which provides quick identification and ...Check website for latest pricing and availability. Learn More";

  static Future<void> fetchCategories() async {
    AppData.categoryList.clear();
    String url = Utils.url + "/api/categories";
    var res = await http.get(url, headers: {"Authorization": Utils.token});

    if (res.statusCode == 200) {
      List<dynamic> categories = jsonDecode(res.body);

      categories.forEach((oneCategory) {
        var category = Category(
            id: oneCategory['category_id'],
            name: oneCategory['category_name'],
            image: Utils.url + '/api/images?url=' + oneCategory['image']);
        AppData.categoryList.add(category);
      });
    }
  }

  static Future<void> fetchMyCart() async {
    AppData.cartList.clear();

    String url =
        Utils.url + "/api/cart?customer_id=${Utils.customerInfo.userID}";

    var res = await http.get(url, headers: {"Authorization": Utils.token});

    if (res.statusCode == 200) {
      List<dynamic> cartData = jsonDecode(res.body);

      int i = 0;
      cartData.forEach((oneCart) {
        List<dynamic> img = [];
        img.add(oneCart['image_url']);

        Product prod = Product(
            id: oneCart['product_id'],
            cartID: oneCart['cart_id'],
            name: oneCart['product_name'],
            price: oneCart['price'].toDouble(),
            image: img,
            category: "",
            quantity: oneCart['quantity'],
            index: i,
            numberInStock: oneCart['number_in_stock'],
            minOrder: oneCart['min_order']);

        AppData.cartList.add(prod);
        ++i;
      });
    }
  }

  static Future<void> fetchAllProducts() async {
    AppData.productList.clear();

    String url = Utils.url + "/api/products";
    var res = await http.get(url, headers: {"Authorization": Utils.token});

    if (res.statusCode == 200) {
      List<dynamic> productData = jsonDecode(res.body);

      int i = 0;
      productData.forEach((oneProduct) {
        if (i < 20) {
          var product = oneProduct['main_product'];
          var sub = oneProduct['sub_products'];

          List<dynamic> img = product['image_url'];

          List<SubProduct> listOfSubProducts = [];

          sub.forEach((oneSub) {

            listOfSubProducts.add(SubProduct(
              id: oneSub['type_id'],
              name: oneSub['name'],
              category: oneSub['type'],
              description: oneSub['description'],
              price: oneSub['price'].toDouble(),
              numberInStock: oneSub['number_in_stock'],
              image: oneSub['image_url'],
              minOrder: oneSub['min_order'],
            ));
          });

          Product prod = Product(
              id: product['product_id'],
              name: product['product_name'],
              price: product['price'].toDouble(),
              image: img,
              category: "Latest Stock",
              minOrder: product['min_order'],
              description: product['description'],
              subProducts: listOfSubProducts);

          AppData.productList.add(prod);
        }
        ++i;
      });
    }
  }
}
