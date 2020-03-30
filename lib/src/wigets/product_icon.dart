import 'package:flutter/material.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/themes/theme.dart';
import 'package:quagga/src/wigets/title_text.dart';
import 'package:quagga/src/model/category.dart';




class ProductIcon extends StatelessWidget {
  // final String imagePath;
  // final String text;
  // final bool isSelected;
  final  Category model;
  ProductIcon({Key key,this.model})
      : super(key: key);

  Widget build(BuildContext context) {
    return model.id == null ? Container(width: 5,)
    : Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      padding: AppTheme.hPadding,
      alignment: Alignment.center,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: model.isSelected ? LightColor.background : Colors.transparent,
        border: Border.all(
            color: model.isSelected ? LightColor.orange : LightColor.grey,
            width: model.isSelected ? 2 : 1),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: model.isSelected ?  Color(0xfffbf2ef) : Colors.white,
             blurRadius: 10,
              spreadRadius: 5,
              offset: Offset(5,5)
              ),
        ],
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 15,
            backgroundColor: LightColor.orange.withAlpha(40),
            backgroundImage: NetworkImage(model.image, scale: 1.0),
          ),
          SizedBox(width: 5.0),
          model.name == null ? Container()
          : Container(
            child: TitleText(
              text: model.name,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}
