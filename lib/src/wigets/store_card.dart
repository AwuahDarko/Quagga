import 'package:flutter/material.dart';
import 'package:quagga/src/model/store.dart';
import 'package:quagga/src/pages/store_products.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/title_text.dart';

class StoreCard extends StatelessWidget {
  StoreCard({Key key, this.model}) : super(key: key);
  Store model;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => StoreProductsPage(model)));
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
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(height: 5),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: LightColor.orange.withAlpha(40),
                      backgroundImage: model.image.isNotEmpty
                          ? NetworkImage(
                          Utils.url + '/api/images?url=' + model.image,
                          scale: 0.5)
                          : null,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                TitleText(
                  text: model.name,
                  fontSize: 14,
                ),
                Container(
                  width: 200,
                  height: 18,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        left: 5,
                        child:  Icon(Icons.location_on, size: 15, color: LightColor.lightOrange2,),
                      ),
                      Positioned(
                        top: 0,
                        left: 33,
                        right: 0,
                        child: TitleText(
                          text: model.streetName + '',
                          fontSize: 12,
                          color: LightColor.grey,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
