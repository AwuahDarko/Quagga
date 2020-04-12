
import 'package:flutter/material.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/themes/theme.dart';
import 'package:quagga/src/wigets/product_icon.dart';
import 'package:quagga/src/wigets/product_card.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.onIconPressedCallback}) : super(key: key);
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

  Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: Theme.of(context).backgroundColor,
          boxShadow: AppTheme.shadow),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  Widget _categoryWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: AppTheme.fullWidth(context),
      height: 70,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: AppData.categoryList
              .map((category) => ProductIcon(
                    model: category,
            onIconPressedCallback: widget.onIconPressedCallback,
                  ))
              .toList()
      ),
    );
  }

  Widget _productWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: AppTheme.fullWidth(context),
      height: AppTheme.fullWidth(context) * .7,
      child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 4 / 3,
              mainAxisSpacing: 30,
              crossAxisSpacing: 20),
          padding: EdgeInsets.only(left: 20),
          scrollDirection: Axis.horizontal,
          children: AppData.productList
              .map((product) => ProductCard(
                    product: product,
                  ))
              .toList()),
    );
  }

  Widget _search() {
    return Container(
      margin: AppTheme.padding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: SizedBox(height: 40,)
//              TextField(
//                decoration: InputDecoration(
//                    border: InputBorder.none,
//                    hintText: "Search Products",
//                    hintStyle: TextStyle(fontSize: 12),
//                    contentPadding:
//                        EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 5),
//                    prefixIcon: Icon(Icons.search, color: Colors.black54)),
//              ),
            ),
          ),
//          SizedBox(width: 20),
//          _icon(Icons.filter_list, color: Colors.black54),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  ListView(
//        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_search(), _categoryWidget(), _productWidget()],
      );
  }
}
