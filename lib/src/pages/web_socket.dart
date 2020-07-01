import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocket extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WebSocketState();
}

class WebSocketState extends State<WebSocket> {
  IO.Socket socket = IO.io(Utils.url, <String, dynamic>{
    'transports': ['websocket']
  });

  ProgressDialog _progressDialog;

  bool done = false;
  String message ='Your payment is being processed';

  @override
  void initState() {
    super.initState();

    socket.connect();
    socket.on('${Utils.customerInfo.clientId}', (data) {
      print(data);
      if(data['message'] == 'Success'){
        message = data['message'];
        setState((){done = true;});
        _placeOrder();
      }else{
        Utils.showStatus(context, true, data['message']);
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = Utils.initializeProgressDialog(context);
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Stack(
                children: <Widget>[
                  Text(message, style: TextStyle(fontWeight: FontWeight.bold),),
                  done ? Text('') : Image.asset('assets/waiting.gif',)
                ],
              ),
            )),
      ),
    );
  }

  Future<void> _placeOrder() async {
    var dt = DateTime.now();
    var nt = dt.add(Duration(days: 60));


    Map<String, dynamic> body = Map();
    body['customer_id'] = Utils.customerInfo.userID;
    body['expiry_date'] = nt.toString();

    List<Map<String, dynamic>> productsList = [];

    AppData.cartList.forEach((oneCartItem) {
      Map<String, dynamic> w = {
        "product_id": oneCartItem.id,
        "quantity": oneCartItem.quantity,
        "price": oneCartItem.price,
        "type": oneCartItem.type
      };

      productsList.add(w);
    });

    body['products'] = productsList;

    _progressDialog.show().then((v) {
      AppData.placeOrder(body).then((status) {
        Future.delayed(Duration(seconds: 1)).then((value) {
          _progressDialog.hide().whenComplete(() {
            Utils.showStatus(context, status, "Your order was successful");
          });
        });
      });
    });
  }
}
