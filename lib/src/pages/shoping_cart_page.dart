import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/model/product.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/themes/theme.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/title_text.dart';
import 'package:getflutter/getflutter.dart';
import 'package:http/http.dart' as http;

class ShoppingCartPage extends StatefulWidget {
  ShoppingCartPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShoppingCartPageState();
  }
}

class ShoppingCartPageState extends State<ShoppingCartPage> {
  ShoppingCartPageState();

  List colors = [];
  List<bool> isSelected = [];
  bool _loading = true;
  Product _currentSelectedItem;
  ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();
    _refreshPage();
  }

  void _refreshPage() {
    AppData.fetchMyCart().then((b) {
      AppData.cartList.forEach((one) {
        colors.add(Colors.transparent);
        isSelected.add(false);
      });
      _loading = false;
      setState(() {});
    });
  }

  Widget _cartItems() {
    return Column(children: AppData.cartList.map((x) => _item(x)).toList());
  }

  Widget _item(Product model) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      color: colors[model.index],
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
                    child: GFAvatar(
                        backgroundImage: model.image.length > 0
                            ? NetworkImage(
                                "${Utils.url}/api/images?url=${model.image[0]}")
                            : null,
                        shape: GFAvatarShape
                            .standard) //Image.network(model.image, width: 90,),
                    )
              ],
            ),
          ),
          Expanded(
              child: ListTile(
                  selected: isSelected[model.index],
                  onLongPress: () {
                    setState(() {
                      if (isSelected[model.index]) {
                        // remove selection

                        colors[model.index] = Colors.transparent;
                        isSelected[model.index] = false;

                        _currentSelectedItem = null;
                      } else {
                        // remove all
                        for (int i = 0; i < AppData.cartList.length; ++i) {
                          colors[i] = Colors.transparent;
                          isSelected[i] = false;
                        }
                        // add current
                        colors[model.index] = Colors.grey[300];
                        isSelected[model.index] = true;

                        // set the selected item
                        _currentSelectedItem = model;
                      }
                    });
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
//                      SizedBox(width: 20.0,),
                    ],
                  ),
                  trailing: Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: LightColor.lightGrey.withAlpha(150),
                        borderRadius: BorderRadius.circular(10)),
                    child: TitleText(
                      text: 'x${model.quantity}',
                      fontSize: 12,
                    ),
                  )))
        ],
      ),
    );
  }

  Widget _price() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TitleText(
          text: '${AppData.cartList.length} Items',
          color: LightColor.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        TitleText(
          text: 'GH\u20B5  ${getPrice()}',
          fontSize: 18,
        ),
      ],
    );
  }

  Widget _submitButton(BuildContext context) {
    return FlatButton(
        onPressed: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: LightColor.orange,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12),
          width: AppTheme.fullWidth(context) * .7,
          child: TitleText(
            text: 'Next',
            color: LightColor.background,
            fontWeight: FontWeight.w500,
          ),
        ));
  }

  double getPrice() {
    double price = 0;
    AppData.cartList.forEach((x) {
      price += x.price * x.quantity;
    });
    return price;
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = Utils.initializeProgressDialog(context);
    return Container(
        height: MediaQuery.of(context).size.height,
        padding: AppTheme.padding,
        child: SafeArea(
          child: Stack(
//          fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                  right: 0,
                  top: 0,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle,
                          color: LightColor.orange,
                          size: 15.0,
                        ),
                        onPressed: () {
                          if (_currentSelectedItem != null && (_currentSelectedItem.quantity > _currentSelectedItem.minOrder)) {
                            _progressDialog.show().then((v){
                              _decreaseQuantity(_currentSelectedItem.cartID,
                                  _currentSelectedItem.quantity)
                                  .then((status) {
                                if (_progressDialog.isShowing()) {
                                  _progressDialog.hide().then((v) {
                                    if (status) {
                                      setState(() {
                                        _currentSelectedItem.quantity -= _currentSelectedItem.minOrder;
                                      });
                                    }
                                  });
                                }
                              });
                            });

                          }
                        },
                      ),
                      SizedBox(width: 10.0),
                      IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            color: LightColor.orange,
                            size: 15.0,
                          ),
                          onPressed: () {
                            if (_currentSelectedItem != null && (_currentSelectedItem.quantity < _currentSelectedItem.numberInStock)) {
                              _progressDialog.show().then((v){
                                _increaseQuantity(_currentSelectedItem.cartID,
                                    _currentSelectedItem.quantity)
                                    .then((status) {
                                  if (_progressDialog.isShowing()) {
                                    _progressDialog.hide().then((v) {
                                      if (status) {
                                        setState(() {
                                          _currentSelectedItem.quantity += _currentSelectedItem.minOrder;
                                        });
                                      }
                                    });
                                  }
                                });
                              });
                            }
                          }),
                      SizedBox(width: 10.0),
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: LightColor.orange,
                            size: 17.0,
                          ),
                          onPressed: () {
                            if (_currentSelectedItem != null) {
                              Utils.deleteDialog(context, "Delete this item?")
                                  .then((response) {
                                if (response) {
                                  _progressDialog.show();
                                  _deleteCartItem(_currentSelectedItem.cartID)
                                      .then((status) {
                                    if (_progressDialog.isShowing()) {
                                      _progressDialog.hide().then((v) {
                                        _refreshPage();
                                        Utils.showStatus(
                                            context, status, "Item Deleted");
                                      });
                                    }
                                  });
                                }
                              });
                            }
                          })
                    ],
                  )),
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _loading ? CircularProgressIndicator() : _cartItems(),
                      Divider(
                        thickness: 1,
                        height: 70,
                      ),
                      _price(),
                      SizedBox(height: 30),
                      _submitButton(context),
                      SizedBox(height: 50.0)
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future<bool> _deleteCartItem(int cartId) async {
    String url = Utils.url + "/api/cart?cart_id=$cartId";

    var res = await http.delete(url, headers: {"Authorization": Utils.token});

    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _increaseQuantity(int cartID, int quantity) async {
    Map<String, int> body = {"cart_id": cartID, "quantity": quantity + 1};

    String json = jsonEncode(body);

    String url = Utils.url + "/api/cart";

    var res = await http.patch(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": Utils.token
        },
        body: json);

    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _decreaseQuantity(int cartID, int quantity) async {
    Map<String, int> body = {"cart_id": cartID, "quantity": quantity - 1};

    String json = jsonEncode(body);

    String url = Utils.url + "/api/cart";

    var res = await http.patch(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": Utils.token
        },
        body: json);

    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
