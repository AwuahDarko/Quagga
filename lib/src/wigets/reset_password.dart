import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/title_text.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ResetPasswordState();
  }
}

class ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  var _controller = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
          height: 200.0,
          width: 300.0,
          padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                _loading
                    ? LinearProgressIndicator()
                    : Container(
                        height: 20,
                      ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                      'Please provide your e-mail, we will send you a link to reset your password'),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          hintText: 'Registered e-mail'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a valid e-mail';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                    child: Row(
                  children: <Widget>[
                    Spacer(),
                    Spacer(),
                    FlatButton(
                      child: Text(
                        'Ok',
                        style: TextStyle(color: Colors.green, fontSize: 16),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate() &&
                            EmailValidator.validate(_controller.text.trim())) {
                          setState(() {
                            _loading = true;
                          });
                          bool res = await _sendEmail(_controller.text.trim());
                          if (res) {
                            setState(() {
                              _loading = false;
                            });
                            Fluttertoast.showToast(
                                msg:
                                    'Password reset link has been sent to your mail',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.black,
                                textColor: Colors.white);
                            Navigator.pop(context, true);
                          } else {
                            setState(() {
                              _loading = false;
                            });
                            Fluttertoast.showToast(
                                msg: 'An error occurred try again',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.black,
                                textColor: Colors.white);
                          }
                        }
                      },
                    ),
                  ],
                ))
              ],
            ),
          )),
    );
  }

  Future<bool> _sendEmail(email) async {
    String url = Utils.url + '/send-reset-password?email=$email';

    try {
      var res = await http.get(url);

      if (res.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
