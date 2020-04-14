import 'package:flutter/material.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/wigets/circularContainer.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double btnHeight = 50;
    Color btnColor = LightColor.orange;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _header(context),
            SizedBox(height: 40,),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              height: btnHeight,
              child: RaisedButton(
                color: btnColor,
                child: Text(
                  "Add New Category",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      '/newcategory'
                  );
                },
              ),
            ),
            SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              height: btnHeight,
              child: RaisedButton(
                color: btnColor,
                child: Text(
                  "Add New Product",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      '/newproduct'
                  );
                },
              ),
            ),
            SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              height: btnHeight,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                child: Text("Add Sub Product",
                  style: TextStyle(color: Colors.white),
                ),
                color: btnColor,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      '/subproduct'
                  );
                },
              ),
            ),
            SizedBox(height: 20,),
//            Container(
//              padding: const EdgeInsets.only(left: 10, right: 10),
//              height: btnHeight,
//              width: MediaQuery.of(context).size.width,
//              child: RaisedButton(
//                child: Text("Remove Product",
//                  style: TextStyle(color: Colors.white),
//                ),
//                color: btnColor,
//                onPressed: () {},
//              ),
//            ),
//            SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              height: btnHeight,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                child: Text("Orders",
                  style: TextStyle(color: Colors.white),
                ),
                color: btnColor,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      '/ordersummary'
                  );
                },
              ),
            ),
//            SizedBox(height: 20,),
//            Container(
//              padding: const EdgeInsets.only(left: 10, right: 10),
//              height: btnHeight,
//              width: MediaQuery.of(context).size.width,
//              child: RaisedButton(
//                child: Text("Create New Store",
//                  style: TextStyle(color: Colors.white),
//                ),
//                color: btnColor,
//                onPressed: () {},
//              ),
//            ),
//            SizedBox(height: 20,),
//            Container(
//              padding: const EdgeInsets.only(left: 10, right: 10),
//              height: btnHeight,
//              width: MediaQuery.of(context).size.width,
//              child: RaisedButton(
//                child: Text("Close Down Store",
//                  style: TextStyle(color: Colors.white),
//                ),
//                color: btnColor,
//                onPressed: () {},
//              ),
//            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
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
                                "Menu",
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
}
