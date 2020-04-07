import 'package:flutter/material.dart';
import 'package:quagga/src/pages/mainPage.dart';
import 'package:quagga/src/pages/product_detail.dart';
import 'package:quagga/src/pages/welcomePage.dart';

class Routes{
  static Map<String,WidgetBuilder> getRoute(){
    return  <String, WidgetBuilder>{
          '/': (_) => WelcomePage(),
           '/detail': (_) => ProductDetailPage()
        };
  }
}