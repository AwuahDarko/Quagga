import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/model/product.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/themes/theme.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/title_text.dart';
import 'package:getflutter/getflutter.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ShoppingCartPage extends StatefulWidget {
  ShoppingCartPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShoppingCartPageState();
  }
}

class ShoppingCartPageState extends State<ShoppingCartPage> {
  ShoppingCartPageState();

  List colors = [];
  List<bool> isSelected = [];
  bool _loading = true;
  Product _currentSelectedItem;
  ProgressDialog _progressDialog;
  var newFormat = DateFormat('yyyy-MM-dd');
  bool _showBtn = false;
  var uuid = Uuid();
  String reference = '';
  String targetEnvironment = '';
  String apiKey = '';
  String accessToken = '';
  String paymentRef = '';
  String phoneNumber = Utils.customerInfo.phone;

  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshPage();
  }

  void _refreshPage() {
    AppData.fetchMyCart().then((b) {
      colors = [];
      isSelected = [];
      AppData.cartList.forEach((one) {
        colors.add(Colors.transparent);
        isSelected.add(false);
      });
      _loading = false;
      setState(() {});
    });
  }

  Widget _cartItems() {
    return Column(children: AppData.cartList.map((x) => _item(x)).toList());
  }

  Widget _item(Product model) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      color: colors[model.index],
      height: 80,
      child: Row(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.2,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 70,
                    width: 70,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            decoration: BoxDecoration(
                                color: LightColor.lightGrey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    left: 0,
                    bottom: 0,
                    top: 0.0,
                    right: 20.0,
                    child: GFAvatar(
                        backgroundImage: model.image.length > 0
                            ? NetworkImage(
                                "${Utils.url}/api/images?url=${model.image[0]}")
                            : null,
                        shape: GFAvatarShape
                            .standard) //Image.network(model.image, width: 90,),
                    )
              ],
            ),
          ),
          Expanded(
              child: ListTile(
                  selected: isSelected[model.index],
                  onTap: () {
                    setState(() {
                      _showBtn = false;
                      if (isSelected[model.index]) {
                        // remove selection

                        colors[model.index] = Colors.transparent;
                        isSelected[model.index] = false;

                        _currentSelectedItem = null;
                      } else {
                        _showBtn = true;
                        // remove all
                        for (int i = 0; i < AppData.cartList.length; ++i) {
                          colors[i] = Colors.transparent;
                          isSelected[i] = false;
                        }
                        // add current
                        colors[model.index] = Colors.grey[300];
                        isSelected[model.index] = true;

                        // set the selected item
                        _currentSelectedItem = model;
                      }
                    });
                  },
                  title: TitleText(
                    text: model.name,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      TitleText(
                        text: 'GH\u20B5 ',
                        color: LightColor.red,
                        fontSize: 12,
                      ),
                      TitleText(
                        text: '${model.price.toStringAsFixed(2)}',
                        fontSize: 14,
                      ),
                    ],
                  ),
                  trailing: Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: LightColor.lightGrey.withAlpha(150),
                        borderRadius: BorderRadius.circular(10)),
                    child: TitleText(
                      text: 'x${model.quantity}',
                      fontSize: 12,
                    ),
                  )))
        ],
      ),
    );
  }

  Widget _price() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TitleText(
          text: '${AppData.cartList.length} Items',
          color: LightColor.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        TitleText(
          text: 'GH\u20B5  ${getPrice().toStringAsFixed(2)}',
          fontSize: 18,
        ),
      ],
    );
  }

  Widget _submitButton(BuildContext context) {
    return FlatButton(
        onPressed: () async {
          if (AppData.cartList.length > 0) {
            _performPayment();
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: LightColor.orange,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12),
          width: AppTheme.fullWidth(context) * .7,
          child: TitleText(
            text: 'Place Order',
            color: LightColor.background,
            fontWeight: FontWeight.w500,
          ),
        ));
  }

  double getPrice() {
    double price = 0;
    AppData.cartList.forEach((x) {
      price += x.price * x.quantity;
    });
    return price;
  }

  void showFailedDialog(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text(
        "Sorry",
        style: TextStyle(fontSize: 16, color: Colors.red),
      ),
      content: Text("Transaction failed"),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = Utils.initializeProgressDialog(context);
    return Container(
        height: MediaQuery.of(context).size.height,
        padding: AppTheme.padding,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned(
                  right: 0,
                  top: 0,
                  child: Row(
                    children: <Widget>[
                      _showBtn
                          ? IconButton(
                              icon: Icon(
                                Icons.remove_circle,
                                color: LightColor.orange,
                                size: 15.0,
                              ),
                              onPressed: () {
                                if (_currentSelectedItem != null &&
                                    (_currentSelectedItem.quantity >
                                        _currentSelectedItem.minOrder)) {
                                  _progressDialog.show().then((v) {
                                    _decreaseQuantity(
                                            _currentSelectedItem.cartID,
                                            _currentSelectedItem.quantity)
                                        .then((status) {
                                      if (_progressDialog.isShowing()) {
                                        _progressDialog.hide().then((v) {
                                          if (status) {
                                            setState(() {
                                              _currentSelectedItem.quantity -=
                                                  _currentSelectedItem.minOrder;
                                            });
                                          }
                                        });
                                      }
                                    });
                                  });
                                }
                              },
                            )
                          : Text(""),
                      SizedBox(width: 10.0),
                      _showBtn
                          ? IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                color: LightColor.orange,
                                size: 15.0,
                              ),
                              onPressed: () {
                                if (_currentSelectedItem != null &&
                                    (_currentSelectedItem.quantity <
                                        _currentSelectedItem.numberInStock)) {
                                  _progressDialog.show().then((v) {
                                    _increaseQuantity(
                                            _currentSelectedItem.cartID,
                                            _currentSelectedItem.quantity)
                                        .then((status) {
                                      if (_progressDialog.isShowing()) {
                                        _progressDialog.hide().then((v) {
                                          if (status) {
                                            setState(() {
                                              _currentSelectedItem.quantity +=
                                                  _currentSelectedItem.minOrder;
                                            });
                                          }
                                        });
                                      }
                                    });
                                  });
                                }
                              })
                          : Text(""),
                      SizedBox(width: 10.0),
                      _showBtn
                          ? IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: LightColor.orange,
                                size: 17.0,
                              ),
                              onPressed: () {
                                if (_currentSelectedItem != null) {
                                  Utils.deleteDialog(
                                          context, "Delete this item?")
                                      .then((response) {
                                    if (response) {
                                      _progressDialog.show().then((v) {
                                        _deleteCartItem(
                                                _currentSelectedItem.cartID)
                                            .then((status) {
                                          if (_progressDialog.isShowing()) {
                                            _progressDialog.hide().then((v) {
                                              _refreshPage();
                                              Utils.showStatus(context, status,
                                                  "Item Deleted");
                                            });
                                          }
                                        });
                                      });
                                    }
                                  });
                                }
                              })
                          : Text("")
                    ],
                  )),
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _loading ? CircularProgressIndicator() : _cartItems(),
                      Divider(
                        thickness: 1,
                        height: 70,
                      ),
                      _price(),
                      SizedBox(height: 30),
                      _submitButton(context),
                      SizedBox(height: 50.0)
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future<bool> transactionSuccessDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Provide a valid MoMo number"),
            content:
                Text('Please approve the transaction and press OK to proceed'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          );
        });
  }

  Future<bool> phoneNumberDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Provide a valid MoMo number"),
            content: TextField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true),
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          );
        });
  }

  Future<bool> _deleteCartItem(int cartId) async {
    String url = Utils.url + "/api/cart?cart_id=$cartId";

    var res = await http.delete(url, headers: {"Authorization": Utils.token});

    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _increaseQuantity(int cartID, int quantity) async {
    Map<String, int> body = {"cart_id": cartID, "quantity": quantity + 1};

    String json = jsonEncode(body);

    String url = Utils.url + "/api/cart";

    var res = await http.patch(url,
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

  Future<bool> _decreaseQuantity(int cartID, int quantity) async {
    Map<String, int> body = {"cart_id": cartID, "quantity": quantity - 1};

    String json = jsonEncode(body);

    String url = Utils.url + "/api/cart";

    var res = await http.patch(url,
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

  Future<bool> placeOrderDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Do you want to place order ?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                color: Colors.deepPurpleAccent,
                onPressed: () => Navigator.pop(context, true),
              ),
              FlatButton(
                child: Text("No"),
                color: Color(0xFFDC143C),
                onPressed: () => Navigator.pop(context, false),
              )
            ],
          );
        });
  }

  Future<bool> _generateAPIUser() async {
    String url = Utils.momoUrl + '/v1_0/apiuser';

    Map<String, String> map = {"providerCallbackHost": Utils.momoCallbackUrl};

    var json = jsonEncode(map);

    reference = uuid.v4();

    var res = await http.post(url,
        headers: {
          'X-Reference-Id': reference,
          'Ocp-Apim-Subscription-Key': Utils.momoPrimaryKey,
          'Content-Type': 'application/json',
        },
        body: json);

    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _getCreatedUserInfo() async {
    String url = Utils.momoUrl + '/v1_0/apiuser/$reference';

    var res = await http.get(
      url,
      headers: {'Ocp-Apim-Subscription-Key': Utils.momoPrimaryKey},
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);
      targetEnvironment = response['targetEnvironment'];

      return true;
    } else {
      return false;
    }
  }

  Future<bool> _generateAPIKey() async {
    String url = Utils.momoUrl + '/v1_0/apiuser/$reference/apikey';

    var res = await http.post(url, headers: {
      'Ocp-Apim-Subscription-Key': Utils.momoPrimaryKey,
      'Content-Type': 'application/json'
    });

    if (res.statusCode == 201) {
      Map<String, dynamic> map = jsonDecode(res.body);
      apiKey = map['apiKey'];
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _generateToken() async {
    String url = Utils.momoUrl + '/collection/token/';

    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$reference:$apiKey'));

    var res = await http.post(url, headers: {
      'Authorization': basicAuth,
      'Ocp-Apim-Subscription-Key': Utils.momoPrimaryKey
    });

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);
      accessToken = 'access_token';
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _requestToPay() async {
    String url = Utils.momoUrl + '/collection/v1_0/requesttopay';

    Map<String, dynamic> body = Map();
    body['amount'] = '';
    body['currency'] = 'EUR';
    body['externalId'] = 'Payment from falcon stores';
    body['payer'] = {"partyIdType": "MSISDN", "partyId": "02431234568"};
    body['payerMessage'] = 'Payment for puchase of drugs from falcon stores';
    body['payeeNote'] = 'Payment for puchase of drugs from falcon stores';

    String json = jsonEncode(body);
    paymentRef = uuid.v4();

    var res = await http.post(url,
        headers: {
          'X-Reference-Id': paymentRef,
          'X-Target-Environment': targetEnvironment,
          'Content-Type': 'application/json',
          'Ocp-Apim-Subscription-Key': Utils.momoPrimaryKey,
          'Authorization': 'Bearer $accessToken'
        },
        body: json);

    if (res.statusCode == 202) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> _getPaymentStatus() async {
    String url = Utils.momoUrl + '/collection/v1_0/requesttopay/$paymentRef';

    var res = await http.get(url, headers: {
      'Ocp-Apim-Subscription-Key': Utils.momoPrimaryKey,
      'X-Target-Environment': targetEnvironment,
      'Authorization': 'Bearer $accessToken'
    });

    if (res.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(res.body);

      return map['status'];
    } else {
      return 'FAILED';
    }
  }

  void _performPayment() async {
    bool answer = await placeOrderDialog(context);
    if (answer) {
      bool choice = await Utils.requestAndWaitForAction(
          context, 'Use ${Utils.customerInfo.phone} for this transaction ?');
      if (!choice) {
        bool value = await phoneNumberDialog(context);
        if (value) phoneNumber = phoneController.text;
      }

      _progressDialog.show();
      // continue with MoMo transaction
      // 1. generate api user
      bool one = await _generateAPIUser();
      if (one) {
        // 2. get the created user
        bool two = await _getCreatedUserInfo();
        if (two) {
          // 3. generate API KEY
          bool three = await _generateAPIKey();
          if (three) {
            // 4. get token
            bool four = await _generateToken();
            if (four) {
              // 5. request  to pay
              bool five = await _requestToPay();
              if (five) {
                bool last = await transactionSuccessDialog(context);
                if (last) {
                  // 6. get transaction status
                  var result = await _getPaymentStatus();

                  if (result == 'SUCCESSFUL') {
                    await _placeOrder();
                  } else {
                    // TO DO: REPEAT
                    var result = await _getPaymentStatus();
                    if (result == 'SUCCESSFUL') {
                      await _placeOrder();
                    } else {
                      // FATAL ERROR
                      print('Status pending still...');
                    }
                  }
                }
              }
            } else {
              Future.delayed(Duration(seconds: 1)).then((value) {
                _progressDialog.hide().whenComplete(() {
                  showFailedDialog(context);
                });
              });

//              return;
            }
          } else {
            Future.delayed(Duration(seconds: 1)).then((value) {
              _progressDialog.hide().whenComplete(() {
                showFailedDialog(context);
              });
            });
//            return;
          }
        } else {
          Future.delayed(Duration(seconds: 1)).then((value) {
            _progressDialog.hide().whenComplete(() {
              showFailedDialog(context);
            });
          });
//          return;
        }
      } else {
        Future.delayed(Duration(seconds: 1)).then((value) {
          _progressDialog.hide().whenComplete(() {
            showFailedDialog(context);
          });
        });
//        return;
      }
    }
  }

  Future<void> _placeOrder() async {
    var dt = DateTime.now();
    var nt = dt.add(Duration(days: 60));

    print(newFormat.format(nt));

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
        if (_progressDialog.isShowing()) {
          _progressDialog.hide().then((v) {
            Utils.showStatus(context, status, "Your order was successful");
          });
        }
      });
    });
  }
}
