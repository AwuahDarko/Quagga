import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/model/product.dart';
import 'package:quagga/src/pages/signup.dart';
import 'package:quagga/src/utils/customer.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/bezierContainer.dart';
import 'package:http/http.dart' as http;
import 'mainPage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showProgress = false;
  String _message = "";
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = "mjadarko@gmail.com";
    _passwordController.text = "natural";
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title,
      {bool isPassword = false, TextEditingController controller}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      onTap: () {
        var email = _emailController.text;
        var password = _passwordController.text;

        if (email.isNotEmpty && password.isNotEmpty) {
          setState(() {
            _showProgress = true;
          });
          _validateLogin(email.trim(), password.trim()).then((bool status) {

            if (status) {
              _fetchAllProducts().then((v) {
                setState(() {
                  _message = "";
                  _showProgress = false;
                });
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MainPage()));
              });
            }
          });
        } else {
          setState(() {
            _message = "All fields are required";
          });
        }
      },
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpPage()));
            },
            child: Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Q',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'ua',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'gga',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email", controller: _emailController),
        _entryField("Password",
            isPassword: true, controller: _passwordController),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: SizedBox(),
                ),
                _title(),
                SizedBox(
                  height: 20,
                ),
                _showProgress
                    ? CircularProgressIndicator()
                    : Text(
                        _message,
                        style: TextStyle(color: Colors.red),
                      ),
                _emailPasswordWidget(),
                SizedBox(
                  height: 20,
                ),
                _submitButton(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.centerRight,
                  child: Text('Forgot Password ?',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 10.0,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _createAccountLabel(),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    )));
  }

  Future<bool> _validateLogin(String email, String password) async {
    String url = Utils.url + '/api/login';

    try {
      var res =
          await http.post(url, body: {"email": email, "password": password});

      if (res.statusCode == 403) {
        setState(() {
          _showProgress = false;
          _message = res.body;
        });
        return false;
      } else if (res.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(res.body);

        Utils.token = "Bearer " + data['token'];

        Map<String, dynamic> userInfo = data['userInfo'];
        print(Utils.token);

        String name = "${userInfo['first_name']} ${userInfo['last_name']}";

        Utils.customerInfo = CustomerInfo(
            userInfo['customer_id'],
            name,
            userInfo['email'],
            userInfo['type'],
            userInfo['phone'],
            userInfo['image_url']);

        return true;
      }
    } catch (e) {
      setState(() {
        _showProgress = false;
        _message = "Network error!";
        print(e);
      });
      return false;
    }
    return false;
  }

  Future<void> _fetchAllProducts() async{
    String url = Utils.url + "/api/products";
    var res = await http.get(url, headers: {
      "Authorization": Utils.token
    });

    if(res.statusCode == 200){

      List<dynamic> productData = jsonDecode(res.body);


      int i = 0;
      productData.forEach((oneProduct) {
        if(i < 20){
          var product = oneProduct['main_product'];

          List<dynamic> img = product['image_url'];

          Product prod = Product(
              id: product['product_id'],
              name: product['product_name'],
              price: product['price'].toDouble(),
              image: img,
              category: "Latest Stock"
          );

          AppData.productList.add(prod);
        }
        ++i;
      });
    }
  }

}
