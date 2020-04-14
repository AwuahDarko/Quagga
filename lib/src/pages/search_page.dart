import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/model/product.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/themes/theme.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/title_text.dart';
import 'package:getflutter/getflutter.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {

  int _index = 0;

  ProgressDialog _progressDialog;

  List<Product> searchList = [];


  @override
  void initState() {
    super.initState();

    if (Utils.categoryToSearch == 0) {
      _index = 1;
      searchList = List.from(AppData.productList);
    } else{
      searchList = AppData.sortProductsByCategory(
          Utils.categoryToSearch);
      _index = 1;
    }

    setState(() {});

  }

  Widget _productItemWidget() {
    return Column(children: searchList.map((x) => _item(x)).toList());
  }

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
                  onTap: () {
                    Navigator.of(context).pushNamed('/detail', arguments: model);
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
                  trailing: GestureDetector(
                      child: Icon(
                        Icons.add_shopping_cart,
                        color: LightColor.orange,
                      ),
                      onTap: () {
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
                      })
                  )
          )
        ],
      ),
    );
  }

  Future<List<Product>> search(String search) async {
    setState(() {
      _index = 0;
    });
    List<Product> list = [];

    searchList.forEach((oneList){
      if(oneList.name.toLowerCase().contains(search.toLowerCase())){
        list.add(oneList);
      }
    });
    return  list;
  }


  Widget setFloatingActionButton(){
    if(_index == 0){
      return FloatingActionButton(
        child: Icon(Icons.select_all),
        onPressed: () {setState(() {
          _index = 1;
        });},
      );
    }else{
     return FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          setState(() {
            _index = 0;
          });
        } ,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    _progressDialog = Utils.initializeProgressDialog(context);
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: setFloatingActionButton()
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          padding: AppTheme.padding,
          child: SafeArea(
            child: IndexedStack(
              index: _index,
              children: <Widget>[
                GestureDetector( //1.4.1
                  child: SearchBar<Product>(
                    minimumChars: 2,
                    emptyWidget: ListTile(
                      leading: Icon(Icons.warning, color: LightColor.orange,),
                      title: Text("No product found", style: TextStyle(color: Colors.deepOrange),),
                    ),
                    hintText: "Search products",
                    onSearch: search,
                    onItemFound: (Product product, int index) {
                      return _item(product);
                    },
                  ),
                  onTap: (){
                    setState(() {
                      _index = 0;
                    });
                  },
                ),
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _productItemWidget(),
                        Divider(
                          thickness: 1,
                          height: 70,
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          )),
    );
  }
  
}
