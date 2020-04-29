import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/bezierContainer.dart';
import 'package:http/http.dart' as http;
import 'loginPage.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();

  bool _showProgress = false;
  String _message = "";
  bool _termsAgreed = false;

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
            height: 5.0,
          ),
          TextField(
              controller: controller,
              keyboardType: title == "Phone Number"
                  ? TextInputType.phone
                  : TextInputType.text,
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
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      onTap: () {
        if (_termsAgreed) {
          var username = _usernameController.text.trim();
          var email = _emailController.text.trim();
          var phone = _phoneController.text.trim();
          var password = _passwordController.text.trim();
          var confirm = _confirmController.text.trim();

          if (username.isNotEmpty &&
              email.isNotEmpty &&
              phone.isNotEmpty &&
              password.isNotEmpty &&
              confirm.isNotEmpty) {
            if (password != confirm) {
              setState(() {
                _message = "Passwords do not match";
              });
            } else {
              setState(() {
                _showProgress = true;
              });
              _signUpNewUser(username, email, phone, password).then((status) {
                Utils.showStatusAndWaitForAction(context, status, _message)
                    .then((value) {
                  setState(() {
                    _showProgress = false;
                  });
                  if (status) {
                    // move to login
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                });
              });
            }
          } else {
            setState(() {
              _message = "All fields are required";
            });
          }
        } else {
          Fluttertoast.showToast(
              msg: 'Please read and accept terms & conditions',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black,
              textColor: Colors.white);
        }
      },
    );
  }

  Future<bool> _signUpNewUser(username, email, phone, password) async {
    String url = Utils.url + '/api/sign-up';
    var body = {
      'first_name': username,
      'last_name': '',
      'email': email,
      'phone': phone,
      'password': password,
      'secret': 'xNlbjAHjAH394BR09kqGuGZXqSoq54mu',
      'username': ''
    };

    String json = jsonEncode(body);

    var res = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: json);

    if (res.statusCode == 200 || res.statusCode == 201) {
      setState(() {
        _message = res.body;
      });
      return true;
    } else {
      setState(() {
        _message = res.body;
      });
      return false;
    }
  }

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              'Login',
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
          text: 'F',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'al',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'con',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username", controller: _usernameController),
        _entryField("Email", controller: _emailController),
        _entryField("Phone Number", controller: _phoneController),
        _entryField("Password",
            isPassword: true, controller: _passwordController),
        _entryField("Confirm Password",
            isPassword: true, controller: _confirmController),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
                          child: SizedBox(
                            height: 10.0,
                          ),
                        ),
                        _title(),
                        SizedBox(
                          height: 5,
                        ),
                        _showProgress
                            ? CircularProgressIndicator()
                            : Text(_message,
                                style: TextStyle(color: Colors.red)),
                        _emailPasswordWidget(),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: _termsAgreed,
                              activeColor: Colors.green,
                              onChanged: (newValue) {
                                setState(() {
                                  _termsAgreed = newValue;
                                });
                              },
                            ),
                            GestureDetector(
                              child: Text(
                                'I agree to the company\'s terms of use',
                                style: TextStyle(
                                    color: Colors.green,
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed('/privacy',
                                    arguments: {
                                      'head': 'Terms & Conditions',
                                      'file': 'terms.pdf'
                                    });
                              },
                            )
                          ],
                        ),
                        _submitButton(),
                        Expanded(
                          flex: 2,
                          child: SizedBox(),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _loginAccountLabel(),
                  ),
                  Positioned(top: 30, left: 0, child: _backButton()),
                ],
              ),
            )));
  }
}
