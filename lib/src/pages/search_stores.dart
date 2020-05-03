import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/shape/gf_avatar_shape.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/model/product.dart';
import 'package:quagga/src/model/store.dart';
import 'package:quagga/src/pages/store_products.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/title_text.dart';


class SearchStore extends StatefulWidget{
//  final list;
//  SearchStore(this.list);

  @override
  State<StatefulWidget> createState() {
    return SearchStoreState();
  }

}

class SearchStoreState extends State<SearchStore>{

  SearchStoreState();

  ProgressDialog _progressDialog;

  Widget _item(Product model) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      color: Colors.transparent,
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
                    child: GestureDetector(
                      child: GFAvatar(
                          backgroundImage: model.image.length > 0
                              ? NetworkImage(
                              "${Utils.url}/api/images?url=${model.image[0]}")
                              : null,
                          shape: GFAvatarShape.standard),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/detail', arguments: model);
                      },
                    ) //Image.network(model.image, width: 90,),
                )
              ],
            ),
          ),
          Expanded(
              child: ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/detail', arguments: model);
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
                        text: '${model.price.toStringAsFixed(2)}',
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
                      onPressed: () async {
                        Map<String, dynamic> qty = await Utils.setCartQuantity(
                            context, model.minOrder, model.numberInStock);
                        if (qty['res'] == true) {
                          _progressDialog.show().then((v) {
                            Utils.addToCart(model.id, Utils.customerInfo.userID,
                                'main', qty['val'])
                                .then((status) {
                              if (_progressDialog.isShowing()) {
                                _progressDialog.hide().then((bool value) {
                                  Utils.showStatus(
                                      context, status, "Added to cart");
                                });
                              }
                            });
                          });
                        }
                      })))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = Utils.initializeProgressDialog(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SearchBar<Store>(
//            onCancelled: (){setState(() {
//              _searching = false;
//            });},
            minimumChars: 2,
            emptyWidget: ListTile(
              leading: Icon(
                Icons.warning,
                color: LightColor.orange,
              ),
              title: Text(
                "No distributor found",
                style: TextStyle(color: Colors.deepOrange),
              ),
              onTap: (){print('ouch');},
            ),
            hintText: "Search Distributors",
            onSearch: _search,
            onItemFound: (Store item, int index) {
              return ListTile(
                leading: item.image.isNotEmpty ?
                Image.network('${Utils.url}/api/images?url=${item.image}',
                  height: 80, width: 80,): Container(
                  height: 80,
                  width: 80,
                  color: LightColor.lightOrange,
                ),
                title: Text( item.name,
                  style: TextStyle(color: Colors.deepOrange),
                ),
                subtitle: Text(item.streetName),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StoreProductsPage(item)));
                  },
              );
            },
          ),
        ),
      ),
    );
  }


  Future<List<Store>> _search(String search) async {
    List<Store> list = [];

//    setState(() {
//      _searching = true;
//    });


    AppData.storeList.forEach((oneList) {
      if (oneList.name.toLowerCase().contains(search.toLowerCase())) {
        list.add(oneList);
      }
    });
    return list;
  }
}