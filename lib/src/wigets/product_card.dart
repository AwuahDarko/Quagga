//import 'package:flutter/material.dart';
//import 'package:progress_dialog/progress_dialog.dart';
//import 'package:quagga/src/model/product.dart';
//import 'package:quagga/src/themes/light_color.dart';
//import 'package:quagga/src/utils/utils.dart';
//import 'package:quagga/src/wigets/title_text.dart';
//
//class ProductCard extends StatefulWidget {
//  final Product product;
//
//  ProductCard({Key key, this.product}) : super(key: key);
//
//  @override
//  _ProductCardState createState() => _ProductCardState();
//}
//
//class _ProductCardState extends State<ProductCard> {
//  Product model;
//  ProgressDialog _progressDialog;
//  bool isLiked = false;
//
//  @override
//  void initState() {
//    model = widget.product;
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    _progressDialog = Utils.initializeProgressDialog(context);
//    return InkWell(
//      onTap: () {
//        Navigator.of(context).pushNamed('/detail', arguments: model);
////        setState(() {
//
//        // model.isSelected = !model.isSelected;
//        //   AppData.productList.forEach((x) {
//        //     if (x.id == model.id && x.name == model.name) {
//        //       return;
//        //     }
//        //     x.isSelected = false;
//        //   });
//        //   var m = AppData.productList
//        //       .firstWhere((x) => x.id == model.id && x.name == model.name);
//        //   m.isSelected = !m.isSelected;
////        });
//      },
//      child: Container(
//        decoration: BoxDecoration(
//          color: LightColor.background,
//          borderRadius: BorderRadius.all(Radius.circular(20)),
//          boxShadow: <BoxShadow>[
//            BoxShadow(
//                color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
//          ],
//        ),
//        margin: EdgeInsets.symmetric(vertical: 10),
//        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//        child: Stack(
//          alignment: Alignment.center,
//          children: <Widget>[
//            Positioned(
//                right: -10,
//                bottom: -5,
//                child: IconButton(
//                    icon: Icon(
//                      Icons.shopping_cart,
//                      color: LightColor.orange,
//                    ),
//                    onPressed: () {
//                      _progressDialog.show().then((v) {
//                        Utils.addToCart(model.id, Utils.customerInfo.userID,
//                                'main', model.minOrder)
//                            .then((status) {
//                          if (_progressDialog.isShowing()) {
//                            _progressDialog.hide().then((bool value) {
//                              Utils.showStatus(
//                                  context, status, "Added to cart");
//                            });
//                          }
//                        });
//                      });
//                    })),
//            Positioned(
//                top: 0,
//                right: 0,
//                child: InkWell(
//                  onTap: () {
//                    _progressDialog.show().then((v){
//                      Utils.addToFavorites(
//                          model.id, Utils.customerInfo.userID, 'main')
//                          .then((status) {
//                        if(_progressDialog.isShowing()){
//                          print(model.id);
//                          _progressDialog.hide().then((bool value){
//                            Utils.showStatus(context, status, "Added to your wish list");
//                            if(status){
//                              setState(() {
//                                isLiked = !isLiked;
//                              });
//                            }
//                          });
//                        }
//                      });
//                    });
//                  },
//                  child: _icon(isLiked ? Icons.favorite : Icons.favorite_border,
//                      color: isLiked ? LightColor.red : LightColor.lightGrey,
//                      size: 15,
//                      padding: 12,
//                      isOutLine: false),
//                )
//            ),
//            Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                SizedBox(height: 15),
//                Stack(
//                  alignment: Alignment.center,
//                  children: <Widget>[
//                    CircleAvatar(
//                      radius: 75,
//                      backgroundColor: LightColor.orange.withAlpha(40),
//                      backgroundImage: model.image.length > 0
//                          ? NetworkImage(
//                              Utils.url + '/api/images?url=' + model.image[0],
//                              scale: 0.5)
//                          : null,
//                    ),
//                  ],
//                ),
//                SizedBox(height: 5),
//                TitleText(
//                  text: model.name,
//                  fontSize: 16,
//                ),
//                TitleText(
//                  text: model.category,
//                  fontSize: 14,
//                  color: LightColor.skyBlue,
//                ),
//                TitleText(
//                  text: "Min. Order ${model.minOrder}",
//                  fontSize: 14,
//                  color: LightColor.orange,
//                ),
//                TitleText(
//                  text: "GH\u20B5 ${model.price}",
//                  fontSize: 18,
//                ),
//              ],
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget _icon(IconData icon,
//      {Color color = LightColor.iconColor,
//        double size = 20,
//        double padding = 10,
//        bool isOutLine = false}) {
//    return Container(
//      height: 40,
//      width: 40,
//      padding: EdgeInsets.all(padding),
//      // margin: EdgeInsets.all(padding),
//      decoration: BoxDecoration(
//        border: Border.all(
//            color: LightColor.iconColor,
//            style: isOutLine ? BorderStyle.solid : BorderStyle.none),
//        borderRadius: BorderRadius.all(Radius.circular(13)),
//        color:
//        isOutLine ? Colors.transparent : Theme.of(context).backgroundColor,
//        boxShadow: <BoxShadow>[
//          BoxShadow(
//              color: Color(0xfff8f8f8),
//              blurRadius: 5,
//              spreadRadius: 10,
//              offset: Offset(5, 5)),
//        ],
//      ),
//      child: Icon(icon, color: color, size: size),
//    );
//  }
//}
