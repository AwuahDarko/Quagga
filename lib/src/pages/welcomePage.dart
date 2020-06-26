import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quagga/src/pages/distributor_signup.dart';
import 'package:quagga/src/pages/signup.dart';


import 'loginPage.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {


  Widget _submitButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.red[200].withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.blue),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: Text(
          'Register as a buyer',
          style: TextStyle(fontSize: 20, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _signUpButton2() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DistributorSignUpPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: Text(
          'Register as a vendor',
          style: TextStyle(fontSize: 20, color: Colors.green),
        ),
      ),
    );
  }

  Widget _title() {
  return Container(
    width: MediaQuery.of(context).size.width < 600 ?100 : 200,
    height: MediaQuery.of(context).size.width < 600 ?100 : 200,
    child: Image.asset('assets/falcon.png'),
  );
  }

  Widget bottomText(){
        return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Save',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.red,
          ),
          children: [
            TextSpan(
              text: ' Time',
              style: TextStyle(color: Colors.amber, fontSize: 16),
            ),
            TextSpan(
              text: ' Save',
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
            TextSpan(
              text: ' Money',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height,
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
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.white54])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _title(),
                  SizedBox(
                    height: 80,
                  ),
                  _submitButton(),
                  SizedBox(
                    height: 20,
                  ),
                  _signUpButton(),
                  SizedBox(
                    height: 20,
                  ),
                  _signUpButton2(),
                  SizedBox(
                    height: 70,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 5,
              left: 10,
              right: 10,
              child: bottomText(),
            )
          ],
        )
      ),
    );
  }
}
