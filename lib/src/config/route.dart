import 'package:flutter/material.dart';
import 'package:quagga/src/pages/menu_page.dart';
import 'package:quagga/src/pages/new_category.dart';
import 'package:quagga/src/pages/new_product.dart';
import 'package:quagga/src/pages/order_details.dart';
import 'package:quagga/src/pages/product_detail.dart';
import 'package:quagga/src/pages/profile_page.dart';
import 'package:quagga/src/pages/sub_product.dart';
import 'package:quagga/src/pages/welcomePage.dart';
import 'package:quagga/src/pages/store_orders_page.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      '/': (_) => WelcomePage(),
      '/detail': (_) => ProductDetailPage(),
      '/profile': (_) => ProfilePage(),
      '/menu': (_) => MenuPage(),
      '/newcategory': (_) => NewCategory(),
      '/newproduct': (_) => NewProduct(),
      '/subproduct': (_) => AddSubProduct(),
      '/ordersummary': (_) => StoreOrdersPage(),
      '/orderdetails': (_) => OrderDetailsPage()
    };
  }
}
