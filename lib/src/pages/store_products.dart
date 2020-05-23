import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/shape/gf_avatar_shape.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/model/product.dart';
import 'package:quagga/src/model/store.dart';
import 'package:quagga/src/pages/search_products.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/themes/theme.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/store_card_mini.dart';
import 'package:quagga/src/wigets/title_text.dart';

class StoreProductsPage extends StatefulWidget {
  final store;

  StoreProductsPage(this.store);

  @override
  _StoreProductsPageState createState() => _StoreProductsPageState(this.store);
}

class _StoreProductsPageState extends State<StoreProductsPage> {
  _StoreProductsPageState(this.store);

  var width;
  var height;
  ProgressDialog _progressDialog;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _searchList = [];
  bool _loading = true;
  final Store store;

  @override
  void initState() {
    super.initState();

    AppData.fetchAllStoreProducts(store.id).then((list) {
      _searchList = list;
      _loading = false;
      setState(() {});
    });
  }

  Widget _storeItems() {
//    print(_searchList.length);
    return Column(children: _searchList.map((x) => _item(x)).toList());
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
                        text: '${model.price.toStringAsFixed(2)}',
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

  Widget _search() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      margin: AppTheme.padding,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: LightColor.lightGrey,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: RaisedButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchProduct(_searchList))),
          child: Row(
            children: <Widget>[
              Icon(Icons.search, size: 18, color: Colors.black54),
              SizedBox(
                width: 10,
              ),
              Text(
                'Search Products',
                style: TextStyle(color: Colors.grey),
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    _progressDialog = Utils.initializeProgressDialog(context);

    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: height * 0.34, //250,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: store.image.isNotEmpty
                                        ? NetworkImage(
                                            '${Utils.url}/api/images?url=${store.image}')
                                        : Image.asset('assets.white.jpg')
                                            .image) //Colors.indigo[400],
                                ),
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  top: 60,
                                  left: 10,
                                  child: Container(
//                                    color: Colors.white,
                                    decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Text(
                                      store.name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: width * 0.06 //30
                                          ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 120,
                                  left: width * 0.05, // 30,
                                  right: width * 0.05, // 30,
                                  child: Container(
                                      height: height * 0.15,
                                      width: width * 0.1,
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                              .toList())),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _loading
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            child: _storeItems())
                  ],
                ),
              ),
              Positioned(
                top: 20,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    _search()
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}