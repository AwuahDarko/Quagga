import 'dart:convert';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/utils/customer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Utils {
  static const String url =
      'http://10.0.2.2:4000'; //'http://192.168.43.111:4000'; //'http://10.0.2.2:4000'
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

  static Future<bool> addToCart(productID, customerID, type) async {
    Map<String, dynamic> body = {
      "product_id": productID,
      "customer_id": customerID,
      "type": type
    };

    String json = jsonEncode(body);

    String url = Utils.url + '/api/cart';

    var res = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": Utils.token
        },
        body: json);

    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static ProgressDialog initializeProgressDialog(BuildContext context) {
    var progressDialog =
    new ProgressDialog(context, type: ProgressDialogType.Normal);
    progressDialog.style(message: 'progress...');
    progressDialog.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    return progressDialog;
  }

  static void showStatus(BuildContext context, bool status, String message) {
    var alertDialog = AlertDialog(
      title: status ? Text("Success") : Text("Error"),
      content: status ? Text(message) : Text("An Error Occurred"),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

}
