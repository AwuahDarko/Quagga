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

class WishListPage extends StatefulWidget {
  WishListPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WishListPageState();
  }
}

class WishListPageState extends State<WishListPage> {
  WishListPageState();

  List colors = [];
  List<bool> isSelected = [];
  bool _loading = true;
  ProgressDialog _progressDialog;
  Product _currentSelectedItem;

  @override
  void initState() {
    super.initState();
    _refreshPage();
  }

  void _refreshPage() {
    AppData.fetchMyFavorites().then((b) {
      colors = [];
      isSelected =[];
      AppData.wishList.forEach((one) {
        colors.add(Colors.transparent);
        isSelected.add(false);
      });
      _loading = false;
      setState(() {});
    });
  }

  Widget _wishListItems() {
    return Column(children: AppData.wishList.map((x) => _item(x)).toList());
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
                        for (int i = 0; i < AppData.wishList.length; ++i) {
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
                    ],
                  ),
                  trailing: IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: LightColor.orange,
                        size: 25.0,
                      ),
                      onPressed: () {
                        _progressDialog.show().then((v) {
                          Utils.addToCart(model.id, Utils.customerInfo.userID,
                              'main', model.minOrder)
                              .then((status) {
                            if (_progressDialog.isShowing()) {
                              _progressDialog.hide().then((bool value) {
                                Utils.showStatus(
                                    context, status, "Added to cart");
                              });
                            }
                          });
                        });
                      })
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = Utils.initializeProgressDialog(context);
    return Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        padding: AppTheme.padding,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned(
                  right: 0,
                  top: 0,
                  child: Row(
                    children: <Widget>[
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
                                  _deleteWishItem(_currentSelectedItem.favoriteID)
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
                top: 40,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _loading ? CircularProgressIndicator() : _wishListItems(),
                      Divider(
                        thickness: 1,
                        height: 70,
                      ),

                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future<bool> _deleteWishItem(int favoriteID) async {
    String url = Utils.url + "/api/favorites?favorite_id=$favoriteID";
    var res = await http.delete(url, headers: {"Authorization": Utils.token});

    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
