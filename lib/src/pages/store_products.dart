import 'dart:ui';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/shape/gf_avatar_shape.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/model/product.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/store_card_mini.dart';
import 'package:quagga/src/wigets/title_text.dart';

class StoreProductsPage extends StatefulWidget {
  @override
  _StoreProductsPageState createState() => _StoreProductsPageState();
}

class _StoreProductsPageState extends State<StoreProductsPage> {
  var width;
  var height;
  ProgressDialog _progressDialog;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _searchList;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _searchList = AppData.productList;
  }

  Future<List<Product>> search(String search) async {
    setState(() {
      _searching = true;
    });
    List<Product> list = [];

    _searchList.forEach((oneList) {
      if (oneList.name.toLowerCase().contains(search.toLowerCase())) {
        list.add(oneList);
      }
    });
    return list;
  }

  Widget _storeItems() {
    return Column(children: AppData.productList.map((x) => _item(x)).toList());
  }

  Widget _item(Product model) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      color: Colors.transparent,
      height: 80,
      child: Row(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.2,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 70,
                    width: 70,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            decoration: BoxDecoration(
                                color: LightColor.lightGrey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    left: 0,
                    bottom: 0,
                    top: 0.0,
                    right: 20.0,
                    child: GestureDetector(
                      child: GFAvatar(
                          backgroundImage: model.image.length > 0
                              ? NetworkImage(
                                  "${Utils.url}/api/images?url=${model.image[0]}")
                              : null,
                          shape: GFAvatarShape.standard),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/detail', arguments: model);
                      },
                    ) //Image.network(model.image, width: 90,),
                    )
              ],
            ),
          ),
          Expanded(
              child: ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/detail', arguments: model);
                  },
                  title: TitleText(
                    text: model.name,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      TitleText(
                        text: 'GH\u20B5 ',
                        color: LightColor.red,
                        fontSize: 12,
                      ),
                      TitleText(
                        text: model.price.toString(),
                        fontSize: 14,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: LightColor.orange,
                        size: 25.0,
                      ),
                      onPressed: () async {
                        Map<String, dynamic> qty = await Utils.setCartQuantity(
                            context, model.minOrder, model.numberInStock);
                        if (qty['res'] == true) {
                          _progressDialog.show().then((v) {
                            Utils.addToCart(model.id, Utils.customerInfo.userID,
                                    'main', qty['val'])
                                .then((status) {
                              if (_progressDialog.isShowing()) {
                                _progressDialog.hide().then((bool value) {
                                  Utils.showStatus(
                                      context, status, "Added to cart");
                                });
                              }
                            });
                          });
                        }
                      })))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    _progressDialog = Utils.initializeProgressDialog(context);

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        primary: false,
        child: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: height * 0.334, //300,
                color: Colors.white,
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                    width: double.infinity,
                    height: height * 0.28, //250,
                    decoration: BoxDecoration(
                      color: LightColor.lightOrange, //Colors.indigo[400],
                    )),
              ),
              Positioned(
                top: width * 0.18, //70
                left: width * 0.07, //30,
                child: Text(
                  "FinaCash",
                  style: TextStyle(
                      color: Colors.white, fontSize: width * 0.074 //30
                      ),
                ),
              ),
              Positioned(
                top: 130,
                left: width * 0.05, // 30,
                right: width * 0.05, // 30,
                child: Container(
                  height: height * 0.15, //150,
                  width: width * 0.1, // 70,
                    padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.blue[100],
                            blurRadius: 5,
                            offset: Offset(0, 2)),
                        BoxShadow(
                            color: Colors.blueAccent,
                            blurRadius: 5,
                            offset: Offset(0, 2))
                      ]),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: AppData.storeList
                        .map((store) => StoreCardMini(
                      model: store,
                    ))
                        .toList()
                  )
                ),
              ),
              Positioned(
                top: 255,
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 90,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: SearchBar<Product>(
                    minimumChars: 2,
                    emptyWidget: ListTile(
                      leading: Icon(
                        Icons.help,
                        color: LightColor.orange,
                      ),
                      title: Text(
                        "No product found",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    ),
                    hintText: "Search products",
                    onSearch: search,
                    onCancelled: () {
                      setState(() {
                        _searching = false;
                      });
                    },
                    onItemFound: (Product product, int index) {
                      return _item(product);
                    },
                  ),
                ),
              ),
              !_searching
                  ? Positioned(
                      top: 320,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.04, right: width * 0.04, top: 0),
                        child: Container(
                          width: width,
                          height: height * 0.9,
                          child: ListView(
                            children: <Widget>[_storeItems()],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 1,
                      height: 1,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}


/*
Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          left: width * 0.05,
                          top: width * 0.04,
                          bottom: width * 0.02,
                        ),
                        child: Text(
                          "Total Orders",
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: width * 0.04),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: width * 0.05),
                            child: Container(
                              width: width * 0.6,
                              child: Text(
                                "800",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors
                                      .lightBlue[700], //Colors.indigo[400],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: width * 0.04),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: width * 0.12,
                                height: width * 0.11, //65,
                                decoration: BoxDecoration(
                                    color: Colors
                                        .lightBlue[700], //Colors.indigo[400],
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 7,
                                        offset: Offset(2, 2),
                                      )
                                    ]),
                                child: Icon(
                                  Icons.description,
                                  size: width * 0.06,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * 0.008,
                      )
                    ],
                  ),
                  */