//import 'package:flutter/material.dart';
//import 'package:quagga/src/pages/mainPage.dart';
//import 'package:quagga/src/themes/light_color.dart';
//import 'package:quagga/src/themes/theme.dart';
//import 'package:quagga/src/utils/utils.dart';
//import 'package:quagga/src/wigets/title_text.dart';
//import 'package:quagga/src/model/category.dart';
//
//class ProductIcon extends StatefulWidget {
//  ProductIcon({Key key, this.model, this.onIconPressedCallback})
//      : super(key: key);
//  final Category model;
//  final Function(int) onIconPressedCallback;
//
//  @override
//  State<StatefulWidget> createState() {
//    return ProductIconState(
//        model: this.model, onIconPressedCallback: this.onIconPressedCallback);
//  }
//}
//
//class ProductIconState extends State<ProductIcon> {
//  // final String imagePath;
//  // final String text;
//  // final bool isSelected;
//  final Category model;
//  final Function(int) onIconPressedCallback;
//
//  ProductIconState({Key key, this.model, this.onIconPressedCallback});
//
//  Widget build(BuildContext context) {
//    return model.id == null
//        ? Container(
//            width: 5,
//          )
//        : GestureDetector(
//            child: Container(
//              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//              padding: AppTheme.hPadding,
//              alignment: Alignment.center,
//              height: 40,
//              decoration: BoxDecoration(
//                borderRadius: BorderRadius.all(Radius.circular(10)),
//                color: Colors.transparent,
//                border: Border.all(color: LightColor.lightGrey, width: 2),
//                boxShadow: <BoxShadow>[
//                  BoxShadow(
//                      color: Color(0xfffbf2ef),
//                      blurRadius: 10,
//                      spreadRadius: 5,
//                      offset: Offset(5, 5)),
//                ],
//              ),
//              child: Row(
//                children: <Widget>[
//                  CircleAvatar(
//                    radius: 15,
//                    backgroundColor: LightColor.orange.withAlpha(40),
//                    backgroundImage: NetworkImage(model.image, scale: 1.0),
//                  ),
//                  SizedBox(width: 5.0),
//                  model.name == null
//                      ? Container()
//                      : Container(
//                          child: TitleText(
//                            text: model.name,
//                            fontWeight: FontWeight.w700,
//                            fontSize: 15,
//                          ),
//                        )
//                ],
//              ),
//            ),
//            onTap: () {
//              Utils.categoryToSearch = model.id;
//              widget.onIconPressedCallback(1);
//              setState(() {
//
//              });
////              print( Utils.categoryToSearch);
//
////              _handlePressed();
//            },
//          );
//  }
//}
