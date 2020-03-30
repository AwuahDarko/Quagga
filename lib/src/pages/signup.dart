import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quagga/src/wigets/bezierContainer.dart';

import 'loginPage.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 5.0,
          ),
          TextField(
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
    return Container(
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
    );
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
        _entryField("Username"),
        _entryField("Email"),
        _entryField("Phone Number"),
        _entryField("Password", isPassword: true),
        _entryField("Confirm Password", isPassword: true),
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
                        _emailPasswordWidget(),
                        SizedBox(
                          height: 5,
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
