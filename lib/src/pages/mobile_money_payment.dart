import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/pages/web_socket.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class MobileMoneyPayment extends StatefulWidget {
  final totalAmount;
  final isVodafone;
  final method;

  MobileMoneyPayment(this.totalAmount, this.isVodafone, this.method);

  @override
  State<StatefulWidget> createState() => MobileMoneyPaymentState();
}

class MobileMoneyPaymentState extends State<MobileMoneyPayment> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _referenceController = TextEditingController();
  TextEditingController _voucherController = TextEditingController();
  var uuid = Uuid();
  ProgressDialog _progressDialog;

  @override
  void dispose() {
    _phoneController.dispose();
    _referenceController.dispose();
    _voucherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = Utils.initializeProgressDialog(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Info'),
      ),
      body: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          child: SingleChildScrollView(
              child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    autofocus: true,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Phone number',
                        hintText: 'eg: 024xxxxxxx',
                        labelStyle: TextStyle(color: Colors.grey)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _referenceController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Reference',
                        hintText: 'eg: Shopping on ulsorb',
                        labelStyle: TextStyle(color: Colors.grey)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter transaction reference';
                      }
                      return null;
                    },
                  ),
                  widget.isVodafone
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    'Please generate voucher code for payment with Vodafone Cash (Dial *110# and select option 4 to generate code',
                                    style: TextStyle(color: Colors.red[300]),
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _voucherController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: 'Voucher code',
                                    hintText: 'generate a voucher dial *110#',
                                    labelStyle: TextStyle(color: Colors.grey)),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please generate and enter voucher';
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                        )
                      : SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: RaisedButton(
                      color: LightColor.orange,
                      child: Text(
                        'Pay',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {

                          _progressDialog.show().then((value) {
                            var body = getBody();
                            sendData(body).then((result) {
                              Future.delayed(Duration(seconds: 1)).then((value) {
                                _progressDialog.hide().whenComplete(() {
                                 if(!result){
                                   Utils.showStatus(context, result, "");
                                 }else{
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => WebSocket()));
                                 }
                                });
                              });
                            });
                          });


                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ))),
    );
  }

  Map<String, dynamic> getBody() {
    return {
      "customer_number": _phoneController.text.trim(),
      "amount": widget.totalAmount,
      "uni_ref_number": uuid.v4(),
      "ref": _referenceController.text.trim(),
      "method": widget.method,
      "voucher_code": _voucherController.text.trim(),
      "customer_id": Utils.customerInfo.userID,
      "time": DateTime.now().toUtc().toString(),
      "order_id": 'N/A',
      "client_id": Utils.customerInfo.clientId,
    };
  }

  Future<bool> sendData(Map<String, dynamic> body) async {
    String url = Utils.url + '/api/mobile-money';

    String json = jsonEncode(body);

    try {
      var res = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': Utils.token
          },
          body: json);
      print(res.statusCode);
      if(res.statusCode == 202){
        return true;
      }else{
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
