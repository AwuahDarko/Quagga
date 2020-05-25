import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:getflutter/shape/gf_avatar_shape.dart';
import 'package:quagga/src/model/store.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/pages/store_products.dart';


class StoreCardMini extends StatelessWidget {
  StoreCardMini({Key key, this.model}) : super(key: key);
  Store model;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => StoreProductsPage(model)));
      },
      child: Container(
        decoration: BoxDecoration(
//          color: Colors.blue[50],
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
          ],
        ),
        margin: EdgeInsets.only(right: 10),
        padding: const EdgeInsets.only(top: 5),
        height: 30.0,
        width: 80.0,
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GFAvatar(
                  size: 20.0,
                    backgroundImage: model.image.isNotEmpty
                        ? NetworkImage(
                        "${Utils.url}/api/images?url=${model.image}")
                        : null,
                    shape: GFAvatarShape.standard),
                Flexible(
                  child: Text(model.name.split(' ')[0], style: TextStyle(
                    fontSize: 10,
                  ),),
                )
              ],
            ),
      ),
    );
  }

}
