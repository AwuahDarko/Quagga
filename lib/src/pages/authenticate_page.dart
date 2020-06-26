import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/pages/welcomePage.dart';
import 'package:quagga/src/utils/customer.dart';
import 'package:quagga/src/utils/database_helper.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'mainPage.dart';

class AuthenticatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthenticatePageState();
  }
}

class AuthenticatePageState extends State<AuthenticatePage> {
  DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _databaseHelper.initializeDatabase().then((v) {
      _databaseHelper.getToken().then((list) {
        if (list.length > 0) {
          var map = list[0];

          Utils.token = map['token'];

          _authenticate(map['token']).then((bool status) {
            if (status) {
              AppData.fetchAllStores().then((v) {
                setState(() {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MainPage()),
                      (Route<dynamic> route) => false);
                });
              });
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => WelcomePage()),
                  (Route<dynamic> route) => false);
            }
          });
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => WelcomePage()),
              (Route<dynamic> route) => false);
        }
      });
    });
  }

  Future<bool> _authenticate(token) async {
    String url = Utils.url + '/api/authenticate-token';
    try {
      var res = await http.get(url, headers: {'Authorization': token});

      if (res.statusCode == 208) {
        Map<String, dynamic> userInfo = jsonDecode(res.body);
        Utils.customerInfo = CustomerInfo(
            userInfo['customer_id'],
            userInfo['first_name'],
            userInfo['last_name'],
            userInfo['email'],
            userInfo['type'],
            userInfo['phone'],
            userInfo['image_url'],
            userInfo['location']);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => WelcomePage()),
          (Route<dynamic> route) => false);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Container(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.7),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 20.0),
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: 120.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: setImage("assets/falcon.png").image,
                        ))),
                SizedBox(
                  height: 5,
                ),
                Text("Loading...."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Image setImage(String imagePath) {
  AssetImage assetImage = AssetImage(imagePath);
  Image image = Image(image: assetImage);
  return image;
}
