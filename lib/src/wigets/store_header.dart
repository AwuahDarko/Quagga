import 'package:flutter/material.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/store_card_mini.dart';



class StoreHeader extends StatelessWidget implements PreferredSizeWidget{
  final height;
  final store;
  final width;

  StoreHeader({this.height, this.store, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height * 0.115, //250,
//      decoration: BoxDecoration(
//          color: Colors.white,
//          image: DecorationImage(
//              fit: BoxFit.fitWidth,
//              image: store.image.isNotEmpty
//                  ? NetworkImage(
//                  '${Utils.url}/api/images?url=${store.image}')
//                  : Image.asset('assets.white.jpg')
//                  .image) //Colors.indigo[400],
//      ),
      child: Container(
//          height: height * 0.13,
//          width: width * 0.1,
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(10),
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
//      Stack(
//        children: <Widget>[
//          Positioned(
//            top: 0,
//            left: 10,
//            child: Container(
//              decoration: BoxDecoration(
//                  color: Colors.white70,
//                  borderRadius: BorderRadius.all(
//                      Radius.circular(10))),
//              child: Text(
//                store.name,
//                style: TextStyle(
//                    color: Colors.black,
//                    fontSize: width * 0.06 //30
//                ),
//              ),
//            ),
//          ),
//          Positioned(
//            top: 90,
//            left: width * 0.05, // 30,
//            right: width * 0.05, // 30,
//            child:
//          ),
//        ],
//      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(height * 0.15,);

}