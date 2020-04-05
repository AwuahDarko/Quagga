import 'dart:convert';

import 'package:quagga/src/model/product.dart';
import 'package:quagga/src/model/category.dart';
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
    var res = await http.get(url, headers: {
      "Authorization": Utils.token
    });

    if(res.statusCode == 200){
      List<dynamic> categories = jsonDecode(res.body);

      categories.forEach((oneCategory){
        var category = Category(id: oneCategory['category_id'], name: oneCategory['category_name'], image: Utils.url + '/api/images?url=' + oneCategory['image']);
        AppData.categoryList.add(category);
      });

    }
  }

  static Future<void> fetchMyCart() async{
    AppData.cartList.clear();

    String url = Utils.url + "/api/cart?customer_id=${Utils.customerInfo.userID}";

    var res = await http.get(url, headers: {
      "Authorization": Utils.token
    });

    if(res.statusCode == 200){
      List<dynamic> cartData = jsonDecode(res.body);


      cartData.forEach((oneCart) {

        String name = "";
        if(oneCart['product_name'] == null){
          name = oneCart['name'];
        }else{
          name = oneCart['product_name'];
        }

        int id;
        if(oneCart['type_id'] != null){
          id = oneCart['type_id'];
        }else{
          id = oneCart['product_id'];
        }

        List<dynamic> l = [];
        l.add(oneCart['image_url']);
        Product prod = Product(
            id: id,
            name: name,
            price: oneCart['price'].toDouble(),
            image: l,
            category: "Latest Stock",
          quantity: oneCart['quantity']
        );

        AppData.cartList.add(prod);
      });
    }

  }

  static Future<void> fetchAllProducts() async{
    AppData.productList.clear();

    String url = Utils.url + "/api/products";
    var res = await http.get(url, headers: {
      "Authorization": Utils.token
    });

    if(res.statusCode == 200){
      List<dynamic> productData = jsonDecode(res.body);

      int i = 0;
      productData.forEach((oneProduct) {
        if(i < 20){
          var product = oneProduct['main_product'];

          List<dynamic> img = product['image_url'];

          Product prod = Product(
              id: product['product_id'],
              name: product['product_name'],
              price: product['price'].toDouble(),
              image: img,
              category: "Latest Stock"
          );

          AppData.productList.add(prod);
        }
        ++i;
      });
    }
  }
}
