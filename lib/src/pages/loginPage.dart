import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/pages/signup.dart';
import 'package:quagga/src/utils/customer.dart';
import 'package:quagga/src/utils/database_helper.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/bezierContainer.dart';
import 'package:http/http.dart' as http;
import 'package:quagga/src/wigets/reset_password.dart';
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
  DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _databaseHelper.initializeDatabase();
//    _emailController.text = "falcon@gmail.com";
//    _passwordController.text = "nature";
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
          SizedBox(
            height: 5,
          ),
          TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                  hintText: title))
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
                colors: [Colors.blue[300], Colors.blue[400]])),
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
              AppData.fetchAllStores().then((v) {
                setState(() {
                  _message = "";
                  _showProgress = false;

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MainPage()),
                      (Route<dynamic> route) =>
                          false // removes all routes below
//                        ModalRoute.withName('/Home'), // removes all routes until named route
                      );
                });
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
            'Don\'t have an account?',
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
                  color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _title() {
//    return RichText(
//      textAlign: TextAlign.center,
//      text: TextSpan(
//          text: 'U',
//          style: GoogleFonts.portLligatSans(
//            textStyle: Theme.of(context).textTheme.headline4,
//            fontSize: 30,
//            fontWeight: FontWeight.w700,
//            color: Color(0xffe46b10),
//          ),
//          children: [
//            TextSpan(
//              text: 'lso',
//              style: TextStyle(color: Colors.black, fontSize: 30),
//            ),
//            TextSpan(
//              text: 'rb',
//              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
//            ),
//          ]),
//    );
    return Container(
      width: MediaQuery.of(context).size.width < 600 ? 100 : 200,
      height: MediaQuery.of(context).size.width < 600 ? 100 : 200,
      child: Image.asset('assets/falcon.png'),
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
//          Positioned(
//              top: -MediaQuery.of(context).size.height * .15,
//              right: -MediaQuery.of(context).size.width * .4,
//              child: BezierContainer()),
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
                  padding: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    child: Text('Forgot Password?',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                    onTap: () async {
                      bool waitValue = await passwordDialog(context);
                    },
                  ),
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

    var body = {"email": email, "password": password};

    String json = jsonEncode(body);

    try {
      var res = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: json);

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

        Utils.customerInfo = CustomerInfo(
            userInfo['customer_id'],
            userInfo['first_name'],
            userInfo['last_name'],
            userInfo['email'],
            userInfo['type'],
            userInfo['phone'],
            userInfo['image_url'],
            userInfo['location'],
            userInfo['chat_id']);

        await _databaseHelper.insertToken(Utils.token);
        print(await _databaseHelper.getToken());

        return true;
      } else {
        setState(() {
          _showProgress = false;
          _message = res.body;
        });
      }
    } catch (e) {
      setState(() {
        _showProgress = false;
        _message = "Please make sure you have internet connection";
      });
      return false;
    }
    return false;
  }

  Future<bool> passwordDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ResetPassword();
        });
  }
}
