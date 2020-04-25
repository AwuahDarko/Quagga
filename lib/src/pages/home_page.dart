import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/model/store.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/themes/theme.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/store_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.onIconPressedCallback})
      : super(key: key);
  final Function(int) onIconPressedCallback;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  bool _searching = false;



  Widget _productWidget() {
    return Container(
        width: AppTheme.fullWidth(context),
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
                child: _search()
            ),
            !_searching ? Positioned(
                top: 100,
                right: 0,
                left: 0,
                bottom: 0,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: StaggeredGridView.count(
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      children: AppData.storeList
                          .map((store) => StoreCard(
                        model: store,
                      ))
                          .toList(),
                      staggeredTiles: AppData.storeList
                          .map((product) => StaggeredTile.fit(1))
                          .toList(),
                    )
                )
            ) : Positioned(
              top: 100,
              child: Container(
                color: Colors.red,
                height: 50,
              )//SizedBox(width: 1, height: 1,),
            ),


          ]
        )
    );
  }

  Future<List<Store>> search(String search) async {
    List<Store> list = [];

    setState(() {
      _searching = true;
    });


    AppData.storeList.forEach((oneList) {
      if (oneList.name.toLowerCase().contains(search.toLowerCase())) {
        list.add(oneList);
      }
    });
    return list;
  }

  Widget _search() {
    return Container(
      margin: AppTheme.padding,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
                child: SearchBar<Store>(
                  onCancelled: (){setState(() {
                    _searching = false;
                  });},
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
                  hintText: "search distributors",
                  onSearch: search,
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
                      onTap: (){Navigator.of(context).pushNamed('/storeproduct', arguments: item);},
                    );
                  },
                ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _productWidget()
    );
  }
}
