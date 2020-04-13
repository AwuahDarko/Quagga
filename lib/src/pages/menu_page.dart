import 'package:flutter/material.dart';
import 'package:quagga/src/themes/light_color.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double btnHeight = 50;
    Color btnColor = Colors.orange;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightColor.orange,
        title: Text(
          "Menu",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
                child: Text("Create New Store",
                  style: TextStyle(color: Colors.white),
                ),
                color: btnColor,
                onPressed: () {},
              ),
            ),
            SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              height: btnHeight,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                child: Text("Close Down Store",
                  style: TextStyle(color: Colors.white),
                ),
                color: btnColor,
                onPressed: () {},
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
