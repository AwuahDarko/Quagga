import 'package:flutter/material.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/model/product.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/themes/theme.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/title_text.dart';
import 'package:getflutter/getflutter.dart';

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
  var myColor = Colors.white;
  List<bool> isSelected = [];

  @override
  void initState() {
    super.initState();
    AppData.fetchMyCart().then((b) {
      AppData.cartList.forEach((one) {
        colors.add(Colors.transparent);
        isSelected.add(false);
      });
      setState(() {

      });
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
                  onLongPress: (){
                    setState(() {
                      if (isSelected[model.index]) {
                        colors[model.index] = Colors.transparent;
                        isSelected[model.index] = false;
                      } else {
                        colors[model.index] = Colors.grey[300];
                        isSelected[model.index] = true;
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
                  )
              ))
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
      price += x.price * x.id;
    });
    return price;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.padding,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _cartItems(),
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
    );
  }

}
