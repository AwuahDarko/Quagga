import 'dart:convert';

import 'package:quagga/src/model/order_details_model.dart';
import 'package:quagga/src/model/order_summary.dart';
import 'package:quagga/src/model/product.dart';
import 'package:quagga/src/model/category.dart';
import 'package:quagga/src/model/store.dart';
import 'package:quagga/src/model/sub_product.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:http/http.dart' as http;

class AppData {
  static List<Product> productList = [];

  static List<Product> cartList = [];
  static List<Product> wishList = [];
  static List<Category> categoryList = [];
  static List<Store> storeList = [];
  static List<String> showThumbnailList = [
    "http://placekitten.com/90/60",
    "http://placekitten.com/90/60",
    "http://placekitten.com/90/60",
    "http://placekitten.com/90/60",
  ];

  static Future<void> fetchCategories() async {
    AppData.categoryList.clear();
    String url = Utils.url + "/api/categories";
    var res = await http.get(url, headers: {"Authorization": Utils.token});

    if (res.statusCode == 200) {
      List<dynamic> categories = jsonDecode(res.body);

      categories.forEach((oneCategory) {
        String w;
        if (oneCategory['image'] == null) {
          w = "";
        } else {
          w = oneCategory['image'];
        }

        var category = Category(
            id: oneCategory['category_id'],
            name: oneCategory['category_name'],
            image: Utils.url + '/api/images?url=' + w);
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
            minOrder: oneCart['min_order'],
            type: oneCart['type']);

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

      productData.forEach((oneProduct) {
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
            subProducts: listOfSubProducts,
            numberInStock: product['number_in_stock'],
            categoryID: product['category_id']);

        AppData.productList.add(prod);
      });
    }
  }

  static Future<void> fetchAllStores() async{
    storeList.clear();

    String url = Utils.url + "/api/store";

    var res = await http.get(url, headers: {"Authorization": Utils.token});

    if(res.statusCode == 200){
      List<dynamic> storeData = jsonDecode(res.body);

      storeData.forEach((oneStore){
        storeList.add(new Store(
          name: oneStore['name'],
          streetName: oneStore['street_name'],
          image: oneStore['image_url'],
          id: oneStore['store_id'],
          email: oneStore['email'],
          phone: oneStore['cell_number']
        ));
      });
    }
  }

  static Future<void> fetchMyFavorites() async {
    AppData.wishList.clear();

    String url =
        Utils.url + "/api/favorites?customer_id=${Utils.customerInfo.userID}";

    var res = await http.get(url, headers: {"Authorization": Utils.token});

    if (res.statusCode == 200) {
      List<dynamic> favData = jsonDecode(res.body);

      int i = 0;
      favData.forEach((oneFav) {
        List<dynamic> img = [];
        img.add(oneFav['image_url']);

        Product prod = Product(
            id: oneFav['product_id'],
            favoriteID: oneFav['favorite_id'],
            name: oneFav['product_name'],
            price: oneFav['price'].toDouble(),
            image: img,
            index: i,
            type: oneFav['type'],
            minOrder: oneFav['min_order']);

        AppData.wishList.add(prod);
        ++i;
      });
    }
  }

  static List<Product> sortProductsByCategory(int categoryID) {
    List<Product> mList = [];
    productList.forEach((oneProduct) {
      if (oneProduct.categoryID == categoryID) {
        mList.add(oneProduct);
      }
    });

    return mList;
  }

  static Future<List<OrderSummary>> getOrderSummary(int id) async {
    String url = Utils.url + "/api/store-orders?customer_id=$id";

    var res = await http.get(url, headers: {"Authorization": Utils.token});

    List<OrderSummary> mList = [];
    if (res.statusCode == 200 || res.statusCode == 201) {
      List<dynamic> dataList = jsonDecode(res.body);

      dataList.forEach((oneData) {
        String publicID = oneData['public_id'];
        Map<String, dynamic> userInfo = oneData['user_info'];

        mList.add(OrderSummary(
            publicID: publicID,
            customerID: userInfo['customer_id'],
            name: '${userInfo['first_name']} ${userInfo['last_name']}',
            email: userInfo['email'],
            image: userInfo['image_url'],
            phone: userInfo['phone'],
            username: userInfo['username'],
            location: userInfo['location']));
      });
    }

    return mList;
  }

  static Future<List<OrderDetailsModel>> fetchOrderDetails(String key) async {
    String url = Utils.url + "/api/store-order-details?public_id=$key";

    var res = await http.get(url, headers: {"Authorization": Utils.token});

    List<OrderDetailsModel> mList = [];

    if (res.statusCode == 200) {
      List<dynamic> dataList = jsonDecode(res.body);

      dataList.forEach((oneData) {
        mList.add(OrderDetailsModel(
            productName: oneData['product_name'],
            image: oneData['image_url'],
            quantity: oneData['quantity'],
            orderID: oneData['order_id'],
            orderKey: oneData['order_key'],
            status: oneData['status'],
            price: oneData['price'].toDouble()));
      });
    }

    return mList;
  }

  static Future<bool> placeOrder(Map<dynamic, dynamic> body) async {
    String json = jsonEncode(body);

    print(json);

    String url = Utils.url + '/api/orders';

    var res = await http.post(url,
        headers: {
          "Authorization": Utils.token,
          "Content-Type": "application/json"
        },
        body: json);

    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<OrderDetailsModel>> fetchCustomerOrderDetails(id) async{
    String url = Utils.url + "/api/orders?customer_id=$id";

    var res = await http.get(url, headers: {"Authorization": Utils.token});

    List<OrderDetailsModel> mList = [];

    if (res.statusCode == 200 || res.statusCode == 201) {
      List<dynamic> dataList = jsonDecode(res.body);

      dataList.forEach((oneData) {
        mList.add(OrderDetailsModel(
            productName: oneData['product_name'],
            image: oneData['image_url'],
            quantity: oneData['quantity'],
            orderID: oneData['order_id'],
            orderKey: oneData['order_key'],
            status: oneData['status'],
            price: oneData['price'].toDouble()));
      });
    }

    return mList;
  }
}
