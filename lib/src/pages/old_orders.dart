import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/model/order_summary.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/themes/theme.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/circularContainer.dart';

import 'order_details.dart';

class StoreOldOrdersPage extends StatefulWidget {
  StoreOldOrdersPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StoreOldOrdersPageState();
  }
}

class StoreOldOrdersPageState extends State<StoreOldOrdersPage> {
  StoreOldOrdersPageState({Key key});

  double width;
  bool _loading = true;
  List<OrderSummary> orderSummaryList = [];

  @override
  void initState() {
    super.initState();
    AppData.getOldOrderSummary().then((result) {
      orderSummaryList = result;
      _loading = false;
      setState(() {});
    });
  }

  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      child: Container(
          height: 120,
          width: width,
          decoration: BoxDecoration(
            color: LightColor.orange,
          ),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                  top: 10,
                  right: -120,
                  child: CircularContainer(300, LightColor.lightOrange2)),
              Positioned(
                  top: -60,
                  left: -65,
                  child: CircularContainer(width * .5, LightColor.darkOrange)),
              Positioned(
                  top: -230,
                  right: -30,
                  child: CircularContainer(width * .7, Colors.transparent,
                      borderColor: Colors.white38)),
              Positioned(
                  top: 50,
                  left: 0,
                  child: Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.white,
                              size: 40,
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Orders",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500),
                              ))
                        ],
                      ))),
            ],
          )),
    );
  }

  Widget _courseList() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: orderSummaryList
                .map(
                  (oneSum) => _orderInfo(
                  oneSum, _decorationContainerB(oneSum.image),
                  background: LightColor.darkOrange),
            )
                .toList()),
      ),
    );
  }

  Widget _card(
      {Color primaryColor = Colors.redAccent,
        String imgPath,
        Widget backWidget}) {
    return Container(
        height: 190,
        width: width * .34,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(0, 5),
                  blurRadius: 10,
                  color: Color(0x12000000))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: backWidget,
        ));
  }

  Widget _orderInfo(OrderSummary model, Widget decoration, {Color background}) {
    return GestureDetector(
      child: Container(
          height: 170,
          width: width - 20,
          child: Row(
            children: <Widget>[
              AspectRatio(
                aspectRatio: .7,
                child: _card(primaryColor: background, backWidget: decoration),
              ),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15),
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: Text(model.name,
                                  style: TextStyle(
                                      color: LightColor.purple,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            CircleAvatar(
                              radius: 3,
                              backgroundColor: background,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("",
                                style: TextStyle(
                                  color: LightColor.grey,
                                  fontSize: 14,
                                )),
                            SizedBox(width: 10)
                          ],
                        ),
                      ),
                      Text(model.username,
                          style: AppTheme.h6Style.copyWith(
                            fontSize: 16,
                            color: LightColor.grey,
                          )),
                      SizedBox(height: 15),
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Colors.deepOrange,
                                size: 16.0,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(model.location,
                                  overflow: TextOverflow.fade,
                                  style: AppTheme.h6Style.copyWith(
                                      fontSize: 16,
                                      color: LightColor.extraDarkPurple))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              _chip(model.email, LightColor.darkOrange, height: 5),
                              SizedBox(
                                width: 10,
                              ),
                              _chip(model.phone, LightColor.darkBlue, height: 5),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Order ID:",
                                style: TextStyle(color: Colors.green),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(model.publicID)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          )),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OrderDetailsPage(model.publicID);
        }));
      },
    );
  }

  Widget _chip(String text, Color textColor,
      {double height = 0, bool isPrimaryCard = false}) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: textColor.withAlpha(isPrimaryCard ? 200 : 50),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: isPrimaryCard ? Colors.white : textColor, fontSize: 15),
      ),
    );
  }

  Widget _decorationContainerB(String imageUrl) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: -65,
          left: -65,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: LightColor.lightOrange2,
            child: CircleAvatar(
                radius: 30, backgroundColor: LightColor.darkOrange),
          ),
        ),
        Positioned(
            bottom: -35,
            right: -40,
            child: CircleAvatar(
                backgroundColor: LightColor.lightOrange2, radius: 40)),
        Positioned(
          top: 50,
          left: -40,
          child: CircularContainer(70, Colors.transparent,
              borderColor: Colors.white),
        ),
        Positioned(
            top: 10.0,
            left: 0,
            right: 0.0,
            child: CircleAvatar(
              backgroundColor: LightColor.yellow,
              radius: 45,
              backgroundImage: imageUrl.isEmpty
                  ? Image.asset("assets/avatar.jpeg").image
                  : NetworkImage('${Utils.url}/api/images?url=$imageUrl'),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  _header(context),
                  SizedBox(height: 20),
                  _loading
                      ? Center(
                    child: CircularProgressIndicator(),
                  )
                      : orderSummaryList.length == 0
                      ? Center(
                    child: Text('No Orders yet'),
                  )
                      : _courseList()
                ],
              ),
            )));
  }
}
