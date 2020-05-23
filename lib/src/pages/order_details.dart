import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/model/order_details_model.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/quad_clipper.dart';
import 'package:quagga/src/wigets/title_text.dart';

class OrderDetailsPage extends StatefulWidget {
  OrderDetailsPage(this.publicKey, {Key key}) : super(key: key);

  final String publicKey;

  @override
  State<StatefulWidget> createState() {
    return OrderDetailsPageState(this.publicKey, key: key);
  }
}

class OrderDetailsPageState extends State<OrderDetailsPage> {
  OrderDetailsPageState(this._publicKey, {Key key});

  double width;
  List<OrderDetailsModel> _list = [];
  final String _publicKey;
  bool _loading = true;

  double _total = 0.00;

  @override
  void initState() {
    super.initState();

    AppData.fetchOrderDetails(_publicKey).then((list) {
      _list = list;
      _loading = false;
      _list.forEach((oneList){
        _total += oneList.price;
      });
      setState(() {});
    });
  }

  Widget _featuredRowB(context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        margin: const EdgeInsets.only(left: 25.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _list
                .map((oneList) => _card(context,
                    primary: Colors.white,
                    chipColor: LightColor.lightpurple,
                    backWidget: _decorationContainerE(
                      LightColor.lightpurple,
                      90,
                      -40,
                      secondary: LightColor.lightseeBlue,
                    ),
                    name: oneList.productName,
                    qty: oneList.quantity.toString(),
                    price: oneList.price.toStringAsFixed(2),
                    status: oneList.status,
                    pub: oneList.orderKey,
                    imgPath: "${Utils.url}/api/images?url=${oneList.image}"))
                .toList()),
      ),
    );
  }

// String name, String qty, String price, String status,String pub
  Widget _card(context,
      {Color primary = Colors.redAccent,
      String imgPath,
      String name = '',
      String qty = '',
      String price = '',
      String status = '',
      String pub = '',
      Widget backWidget,
      Color chipColor = LightColor.orange,
      bool isPrimaryCard = false}) {
    return Container(
        height: isPrimaryCard ? 190 : 180,
        width: MediaQuery.of(context).size.width * 0.85,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
            color: primary.withAlpha(200),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(0, 5),
                  blurRadius: 10,
                  color: LightColor.lightpurple.withAlpha(20))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            child: Stack(
              children: <Widget>[
                backWidget,
                Positioned(
                    top: 20,
                    left: 10,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: NetworkImage(imgPath),
                    )),
                Positioned(
                  top: 10,
                  right: 70,
                  child: _cardInfo(name, qty, price, status, pub,
                      LightColor.titleTextColor, chipColor,
                      isPrimaryCard: isPrimaryCard),
                )
              ],
            ),
          ),
        ));
  }

  Widget _cardInfo(String name, String qty, String price, String status,
      String pub, Color textColor, Color primary,
      {bool isPrimaryCard = false}) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.only(right: 0),
            width: width * .32,
            alignment: Alignment.topCenter,
            child: Text(
              name,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isPrimaryCard ? Colors.white : textColor),
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.only(right: 0),
            width: width * .32,
            alignment: Alignment.topCenter,
            child: Text(
              "Quantity:  $qty",
              style: TextStyle(
                  fontSize: 14,
                  color: isPrimaryCard ? Colors.white : textColor),
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.only(right: 0),
            width: width * .32,
            alignment: Alignment.topCenter,
            child: Text(
              "GH\u20B5  $price",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
          ),
          SizedBox(height: 25),
          Row(
            children: <Widget>[
              SizedBox(
                width: 80,
              ),
              _chip(status, primary, height: 5, isPrimaryCard: isPrimaryCard)
            ],
          )
        ],
      ),
    );
  }

  Widget _chip(String text, Color textColor,
      {double height = 0, bool isPrimaryCard = false}) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: setColor(text),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _decorationContainerE(Color primary, double top, double left,
      {Color secondary}) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: -105,
          left: -35,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: primary.withAlpha(100),
          ),
        ),
        Positioned(
            top: 40,
            right: -25,
            child: ClipRect(
                clipper: QuadClipper(),
                child: CircleAvatar(backgroundColor: primary, radius: 40))),
        Positioned(
            top: 45,
            right: -50,
            child: ClipRect(
                clipper: QuadClipper(),
                child: CircleAvatar(backgroundColor: secondary, radius: 50))),
        _smallContainer(LightColor.yellow, 15, 90, radius: 5)
      ],
    );
  }

  Positioned _smallContainer(Color primary, double top, double left,
      {double radius = 10}) {
    return Positioned(
        top: top,
        left: left,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: primary.withAlpha(255),
        ));
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        persistentFooterButtons: <Widget>[
          Row(
            children: <Widget>[
              TitleText(
                text: "Total:",
              ),
              SizedBox(width: 10,),
              TitleText(
                text: "GH\u20B5",
              ),
              SizedBox(width: 5,),
              TitleText(
                text: "${_total.toStringAsFixed(2)}",
                color: LightColor.orange,
              ),
              SizedBox(width: 20,),
            ],
          )
        ],
        appBar: AppBar(
          title: Text("Order details"),
        ),
        body: SingleChildScrollView(
          child: _loading ? Center(
            child: CircularProgressIndicator(),
          ): Column(
            children: <Widget>[SizedBox(height: 0), _featuredRowB(context)],
          ),
        ));
  }

  setColor(text){
    if(text == 'delivered') return Colors.green.withAlpha(150);
    if(text == 'pending') return Colors.red.withAlpha(150);
    if(text == 'paid') return Colors.orange.withAlpha(150);
  }
}
