
import 'package:quagga/src/utils/customer.dart';
import 'package:flutter/material.dart';

class Utils{
  static const String url = 'http://192.168.43.111:4000'; //'http://10.0.2.2:4000'
  static String token = '';
  static CustomerInfo customerInfo;

  static Future<bool> showStatusAndWaitForAction(
      BuildContext context, bool status, String message) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: status ? Text("Success") : Text("Error"),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          );
        });
  }
}