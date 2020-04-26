import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/model/order_details_model.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/quad_clipper.dart';
import 'package:http/http.dart' as http;




class CustomerOrderDetailsPage extends StatefulWidget {
  CustomerOrderDetailsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomerOrderDetailsPageState(key: key);
  }
}

class CustomerOrderDetailsPageState extends State<CustomerOrderDetailsPage> {
  CustomerOrderDetailsPageState({Key key});

  double width;
  List<OrderDetailsModel> _list = [];
  bool _loading = true;

  ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch(){
    AppData.fetchCustomerOrderDetails(Utils.customerInfo.userID).then((list) {
      _list = list;
      _loading = false;

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
                    pub: oneList.orderID.toString(),
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
        height: 120,
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
                    top: 5,
                    left: 10,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: NetworkImage(imgPath),
                    )),
                Positioned(
                  top: 10,
                  right: 50,
                  child: _cardInfo(name, qty, price, status,
                      LightColor.titleTextColor, chipColor,
                      isPrimaryCard: isPrimaryCard),
                ),
                Positioned(
                  top: 80,
                  right: 5,
                  child: _chip(status, primary, pub , height: 5, isPrimaryCard: isPrimaryCard)
                )
              ],
            ),
          ),
        ));
  }

  Widget _cardInfo(String name, String qty, String price, String status,
      Color textColor, Color primary,
      {bool isPrimaryCard = false}) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 1),
          Container(
              width: width * .32,
              alignment: Alignment.topCenter,
              child: Row(
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isPrimaryCard ? Colors.white : textColor),
                  ),
                ],
              )),
          SizedBox(height: 5),
          Container(
              padding: EdgeInsets.only(right: 0),
              width: width * .32,
              alignment: Alignment.topCenter,
              child: Row(
                children: <Widget>[
                  Text('Qty:  '),
                  Text(
                    "$qty",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                ],
              )),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.only(right: 0),
            width: width * .32,
            alignment: Alignment.topCenter,
            child: Row(
              children: <Widget>[
                Text('GH\u20B5 '),
                Text(
                  price,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
//          _chip(status, primary, height: 5, isPrimaryCard: isPrimaryCard)
        ],
      ),
    );
  }

  Widget _chip(String text, Color textColor, String pub,
      {double height = 0, bool isPrimaryCard = false}) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: text == 'paid'
            ? Colors.green.withAlpha(150)
            : Colors.orange.withAlpha(150),
      ),
      child: text != 'paid'
          ? GestureDetector(
        child: Text(
          "Confirm order received",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        onTap: () async{
        bool response = await Utils.requestAndWaitForAction(context,'Did you receive this order ?');
        if(response){
          _progressDialog.show();
         bool status = await _confirmOrderReceived(pub);
          Future.delayed(Duration(seconds: 1)).then((value) {
            _progressDialog.hide().whenComplete(() {
              Utils.showStatus(
                  context, status, "Ok");
              setState(() {
                _loading = true;
                fetch();
              });
            });
          });
        }
        },
      )
          : Text('pending payment',
              style: TextStyle(color: Colors.white, fontSize: 14)),
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
    _progressDialog = Utils.initializeProgressDialog(context);

    return Scaffold(
        body: SingleChildScrollView(
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _list.isEmpty ? Center(
            child: Text('No orders yet' ,style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: LightColor.orange
            ),),
          ) : Column(
            children: <Widget>[
              SizedBox(height: 5),
              _featuredRowB(context)
            ],
          ),
        ));
  }

  Future<bool> _confirmOrderReceived(id) async{
    String url = Utils.url +  "/api/deliver-order?order_id=$id";

    var res = await http.get(url, headers: {'Authorization': Utils.token});

    if(res.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }

}
