import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/model/product.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/title_text.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  ProductCard({Key key, this.product}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Product model;
  ProgressDialog _progressDialog;

  @override
  void initState() {
    model = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = Utils.initializeProgressDialog(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/detail');
        setState(() {
          // model.isSelected = !model.isSelected;
          //   AppData.productList.forEach((x) {
          //     if (x.id == model.id && x.name == model.name) {
          //       return;
          //     }
          //     x.isSelected = false;
          //   });
          //   var m = AppData.productList
          //       .firstWhere((x) => x.id == model.id && x.name == model.name);
          //   m.isSelected = !m.isSelected;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: LightColor.background,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
          ],
        ),
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
                right: -10,
                bottom: -5,
                child: IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: LightColor.orange,
                    ),
                    onPressed: () {
                      _progressDialog.show().then((v){
                        Utils.addToCart(
                            model.id, Utils.customerInfo.userID, 'main', model.minOrder)
                            .then((status) {
                          if(_progressDialog.isShowing()){
                            _progressDialog.hide().then((bool value){
                              Utils.showStatus(context, status, "Added to cart");
                            });
                          }
                        });
                      });

                    })),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(height: 15),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: LightColor.orange.withAlpha(40),
                      backgroundImage: model.image.length > 0
                          ? NetworkImage(
                              Utils.url + '/api/images?url=' + model.image[0],
                              scale: 0.5)
                          : null,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                TitleText(
                  text: model.name,
                  fontSize: 16,
                ),
                TitleText(
                  text: model.category,
                  fontSize: 14,
                  color: LightColor.orange,
                ),
                TitleText(
                  text: model.price.toString(),
                  fontSize: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
