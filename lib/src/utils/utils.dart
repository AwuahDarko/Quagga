import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/utils/customer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:quagga/src/wigets/get_photo_options.dart';
import 'package:quagga/src/wigets/item_quantity.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uuid/uuid.dart';

class Utils {
  static String url = 'http://192.168.43.111:4000';

  //'http://192.168.43.111:4000'; //'http://10.0.2.2:4000' http://api.piuniversal.com:4000
  static String token = '';
  static CustomerInfo customerInfo;
  static String momoCallbackUrl = 'https://piuniversal.com';
  static String momoPrimaryKey = '6eeb64c949684cc3a8fe5736d2ef0524';
  static String momoUrl = 'https://sandbox.momodeveloper.mtn.com';

  static String networkErrorMessage = 'Please make sure you have internet connection';

  static var uuid = Uuid();

  static Future<bool> showStatusAndWaitForAction(BuildContext context,
      bool status, String message) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: status ? Text("Success") : Text("Error"),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok", style: TextStyle(color: Colors.blue),),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          );
        });
  }

  static Future<bool> requestAndWaitForAction(BuildContext context,
      String message) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
//            title:Text("Confirm"),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes", style: TextStyle(color: Colors.green),),
                onPressed: () => Navigator.pop(context, true),
              ),
              FlatButton(
                child: Text("No", style: TextStyle(color: Colors.red[300]),),
                onPressed: () => Navigator.pop(context, false),
              )
            ],
          );
        });
  }

  static Future<bool> addToCart(productID, customerID, type, qty) async {
    Map<String, dynamic> body = {
      "product_id": productID,
      "customer_id": customerID,
      "type": type,
      "quantity": qty
    };

    String json = jsonEncode(body);

    String url = Utils.url + '/api/cart';

    try {
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
    } catch (e) {
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
//      title: status ? Text("Success", style: TextStyle(
//        fontSize: 20,
//        color: Colors.green
//      ),) : Text("Error", style: TextStyle(
//        fontSize: 20,
//        color: Colors.red
//      ),),
      content: status ? Text(message) : Text("An Error Occurred"),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  static void networkErrorDialog(BuildContext context, String message) {
    var alertDialog = AlertDialog(
      content: Text(message),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  static Future<bool> deleteDialog(BuildContext context, String message) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
//            title: Text("Are you sure?"),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                color: Color(0xFFDC143C),
                onPressed: () => Navigator.pop(context, true),
              ),
              FlatButton(
                child: Text("No"),
                color: Colors.green,
                onPressed: () => Navigator.pop(context, false),
              )
            ],
          );
        });
  }

  static Future<bool> addToFavorites(productID, customerID, type) async {
    Map<String, dynamic> body = {
      "product_id": productID,
      "customer_id": customerID,
      "type": type,
    };

    String json = jsonEncode(body);

    String url = Utils.url + '/api/favorites';

    try {
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
    } catch (e) {
      return false;
    }
  }


  static int categoryToSearch = 0;


  static Future<File> getImageFromCamera(context) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: ImgSource.Camera,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );
    Directory appDocDir = await getApplicationDocumentsDirectory();
    var unique = uuid.v4().toString();
    var compressedImage = await compressImageAndGetFile(
        image, '${appDocDir.path}/$unique.jpg');
    return compressedImage;
  }

  static Future<File> getImageFromGallery(context) async {
    File image = await ImagePickerGC.pickImage(
      context: context,
      source: ImgSource.Gallery,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );
    Directory appDocDir = await getApplicationDocumentsDirectory();
    var unique = uuid.v4().toString();
    var compressedImage = await compressImageAndGetFile(
        image, '${appDocDir.path}/$unique.jpg');
    return compressedImage;
  }


  static Future<int> photoOptionDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return PhotoOption();
        });
  }

  static Future<Map<String, dynamic>> setCartQuantity(BuildContext context,
      int min, int num) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ItemQuantity(min, num);
        });
  }


  static Future<File> compressImageAndGetFile(File file,
      String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 70,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }


  static Future<bool> getUserProfile() async {
    String url = Utils.url + "/api/profile";

    try{
      var res = await http.get(url, headers: {'Authorization': Utils.token});

      if (res.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(res.body);

        Utils.customerInfo = new
        CustomerInfo(
            map['customer_id'],
            map['first_name'],
            map['last_name'],
            map['email'],
            map['type'],
            map['phone'],
            map['image_url'],
            map['location']);
        return true;
      }else{
        return false;
      }
    }catch(e){
      return false;
    }
  }

}

/*
* Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Login()),
          ModalRoute.withName('/Home'),
        );
* */
