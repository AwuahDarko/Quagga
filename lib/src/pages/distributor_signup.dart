import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/bezierContainer.dart';
import 'package:http/http.dart' as http;
import 'loginPage.dart';
import 'dart:io';

class DistributorSignUpPage extends StatefulWidget {
  DistributorSignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DistributorSignUpPageState createState() => _DistributorSignUpPageState();
}

class _DistributorSignUpPageState extends State<DistributorSignUpPage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _storeNameController = TextEditingController();
  TextEditingController _streetNameController = TextEditingController();
  TextEditingController _directorName1Controller = TextEditingController();
  TextEditingController _directorName2Controller = TextEditingController();
  TextEditingController _cellController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _landLineController = TextEditingController();
  TextEditingController _areaController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _ZAMRANumberController = TextEditingController();
  TextEditingController _HPCZNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();

//  bool _showProgress = false;
  String _message = "";
  bool _termsAgreed = false;

  File _image_1;
  File _image_2;
  File _image_3;
  File _image_4;
  File _image_5;

  String _imageName1 = 'Certificate of Incorporation';
  String _imageName2 = 'ZAMRA certificate';
  String _imageName3 = 'HPCZ Full registration';
  String _imageName4 = 'HPCZ annual';
  String _imageName5 = 'Pharmacy Logo';

  ProgressDialog _progressDialog;

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
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }

  Widget _entryField(
    String title, {
    bool isPassword = false,
    TextEditingController controller,
    String type = '',
  }) {
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
              keyboardType:
                  type == "phone" ? TextInputType.phone : TextInputType.text,
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
      onTap: () async {
        if (_termsAgreed) {
          var firstName = _firstNameController.text.trim();
          var email = _emailController.text.trim();
          var password = _passwordController.text.trim();
          var confirm = _confirmController.text.trim();
          var lastName = _lastNameController.text.trim();
          var pharmacy = _storeNameController.text.trim();
          var nameD1 = _directorName1Controller.text.trim();
          var nameD2 = _directorName2Controller.text.trim();
          var cell = _cellController.text.trim();
          var mob = _mobileController.text.trim();
          var land = _landLineController.text.trim();
          var street = _streetNameController.text.trim();
          var area = _areaController.text.trim();
          var city = _cityController.text.trim();
          var country = _countryController.text.trim();
          var zamra = _ZAMRANumberController.text.trim();
          var hpcz = _HPCZNumberController.text.trim();

          if (firstName.isNotEmpty &&
              email.isNotEmpty &&
              password.isNotEmpty &&
              confirm.isNotEmpty &&
              lastName.isNotEmpty &&
              pharmacy.isNotEmpty &&
              nameD1.isNotEmpty &&
              cell.isNotEmpty &&
              street.isNotEmpty &&
              area.isNotEmpty &&
              city.isNotEmpty &&
              zamra.isNotEmpty &&
              country.isNotEmpty &&
              hpcz.isNotEmpty) {
            if (password != confirm) {
              setState(() {
                _message = "Passwords do not match";
              });
            } else {
              _progressDialog.show();

              Map<String, dynamic> body = {
                "first_name": firstName,
                "last_name": lastName,
                "email": email,
                "password": password,
                "store_name": pharmacy,
                "street_name": street,
                "director_name1": nameD1,
                "director_name2": nameD2,
                "cell_number": cell,
                "mobile_number": mob,
                "landline": land,
                "area": area,
                "city": city,
                "country": country,
                "zamra_licence_number": zamra,
                "hpcz_certificate_number": hpcz
              };
              _signUpNewStore(body).then((status) async{
                if(status == false){
                  Future.delayed(Duration(seconds: 1)).then((value) {
                    _progressDialog.hide().whenComplete(() {
                      showStatus(context,  _message);
                    });
                  });
                }else{
                  await _uploadImage(status, _image_1, '/api/cert-corp');
                  await _uploadImage(status, _image_2, '/api/zamra');
                  await _uploadImage(status, _image_3, '/api/hpcz-full');
                  await _uploadImage(status, _image_4, '/api/hpcz-annual');
                  await _uploadImage(status, _image_5, '/api/store-logo');

                  Future.delayed(Duration(seconds: 1)).then((value) {
                    _progressDialog.hide().whenComplete(() {
                      Utils.showStatusAndWaitForAction(context, true, _message)
                          .then((value) {
                        if (value) {
                          // move to login
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (context) => LoginPage()));

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                                  (Route<dynamic> route) => false // removes all routes below
//                        ModalRoute.withName('/Home'), // removes all routes until named route
                          );
                        }
                      });
                    });
                  });
                }

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

  Future<dynamic> _signUpNewStore(Map<String, dynamic> body) async {
    String url = Utils.url + '/api/store';

    String json = jsonEncode(body);

    var res = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: json);

    if (res.statusCode == 200 || res.statusCode == 201) {
        Map<String, dynamic> map = jsonDecode(res.body);
        
        return map['store_id'];
    } else {
      setState(() {
        _message = res.body;
      });
      return false;
    }
  }

  Future<bool> _uploadImage(int storeID, File file, String route) async {
    String url = Utils.url + '$route';

    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(file.path,
          filename: file.path.split("/").last),
      "store_id": storeID
    });

    Dio dio = Dio();
    dio.options.headers["Authorization"] = Utils.token;
    var res = await dio.post(url, data: formData);

    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  void showStatus(BuildContext context, String message) {
    var alertDialog = AlertDialog(
      title: Text("Message", style: TextStyle(
          fontSize: 20,
          color: Colors.green
      ),),
      content: Text(message),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
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

  Widget _inputWidget() {
    return Column(
      children: <Widget>[
        _entryField("First Name", controller: _firstNameController),
        _entryField("Last Name", controller: _lastNameController),
        _entryField("Name of Pharmacy", controller: _storeNameController),
        _entryField("Name of Director 1", controller: _directorName1Controller),
        _entryField("Name of Director 2 (Optional)",
            controller: _directorName2Controller),
        _entryField("Cell Number", type: 'phone', controller: _cellController),
        _entryField("Mobile Number (Optional)",
            type: 'phone', controller: _mobileController),
        _entryField("Landline Number (Optional)",
            type: 'phone', controller: _landLineController),
        _entryField("Street name", controller: _streetNameController),
        _entryField("Area", controller: _areaController),
        _entryField("City", controller: _cityController),
        _entryField("Country", controller: _countryController),
        _entryField("ZAMRA LINCENCE NO.", controller: _ZAMRANumberController),
        _entryField("HPCZ CERTIFICATE NO.", controller: _HPCZNumberController),
        Container(
          child: Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  _imageName1,
                  overflow: TextOverflow.visible,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
              Spacer(),
              RaisedButton(
                color: LightColor.lightOrange,
                child: Text("UPLOAD"),
                onPressed: () {
                  Utils.photoOptionDialog(context).then((value) {
                    if (value == 2) {
                      Utils.getImageFromCamera(context).then((file) {
                        _image_1 = file;
                        if (_image_1 != null) {
                          _imageName1 = file.path.split('/').last;
                        }
                        setState(() {});
                      });
                    } else if (value == 1) {
                      Utils.getImageFromGallery(context).then((file) {
                        _image_1 = file;
                        if (_image_1 != null) {
                          _imageName1 = file.path.split('/').last;
                        }
                        setState(() {});
                      });
                    }
                  });
                },
              )
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  _imageName2 + '                     ',
                  overflow: TextOverflow.visible,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
              Spacer(),
              RaisedButton(
                color: LightColor.lightOrange,
                child: Text("UPLOAD"),
                onPressed: () {
                  Utils.photoOptionDialog(context).then((value) {
                    if (value == 2) {
                      Utils.getImageFromCamera(context).then((file) {
                        _image_2 = file;
                        if (_image_2 != null) {
                          _imageName2 = file.path.split('/').last;
                        }
                        setState(() {});
                      });
                    } else if (value == 1) {
                      Utils.getImageFromGallery(context).then((file) {
                        _image_2 = file;
                        if (_image_2 != null) {
                          _imageName2 = file.path.split('/').last;
                        }
                        setState(() {});
                      });
                    }
                  });
                },
              )
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  _imageName3,
                  overflow: TextOverflow.visible,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
              Spacer(),
              RaisedButton(
                color: LightColor.lightOrange,
                child: Text("UPLOAD"),
                onPressed: () {
                  Utils.photoOptionDialog(context).then((value) {
                    if (value == 2) {
                      Utils.getImageFromCamera(context).then((file) {
                        _image_3 = file;
                        if (_image_3 != null) {
                          _imageName3 = file.path.split('/').last;
                        }
                        setState(() {});
                      });
                    } else if (value == 1) {
                      Utils.getImageFromGallery(context).then((file) {
                        _image_3 = file;
                        if (_image_3 != null) {
                          _imageName3 = file.path.split('/').last;
                        }
                        setState(() {});
                      });
                    }
                  });
                },
              )
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  _imageName4 + '                  ',
                  overflow: TextOverflow.visible,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
              Spacer(),
              RaisedButton(
                color: LightColor.lightOrange,
                child: Text("UPLOAD"),
                onPressed: () {
                  Utils.photoOptionDialog(context).then((value) {
                    if (value == 2) {
                      Utils.getImageFromCamera(context).then((file) {
                        _image_4 = file;
                        if (_image_4 != null) {
                          _imageName4 = file.path.split('/').last;
                        }
                        setState(() {});
                      });
                    } else if (value == 1) {
                      Utils.getImageFromGallery(context).then((file) {
                        _image_4 = file;
                        if (_image_4 != null) {
                          _imageName4 = file.path.split('/').last;
                        }
                        setState(() {});
                      });
                    }
                  });
                },
              )
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  _imageName5 + '                  ',
                  overflow: TextOverflow.visible,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
              Spacer(),
              RaisedButton(
                color: LightColor.lightOrange,
                child: Text("UPLOAD"),
                onPressed: () {
                  Utils.photoOptionDialog(context).then((value) {
                    if (value == 2) {
                      Utils.getImageFromCamera(context).then((file) {
                        _image_5 = file;
                        if (_image_5 != null) {
                          _imageName5 = file.path.split('/').last;
                        }
                        setState(() {});
                      });
                    } else if (value == 1) {
                      Utils.getImageFromGallery(context).then((file) {
                        _image_5 = file;
                        if (_image_5 != null) {
                          _imageName5 = file.path.split('/').last;
                        }
                        setState(() {});
                      });
                    }
                  });
                },
              )
            ],
          ),
        ),
        _entryField("Email", controller: _emailController),
        _entryField("Password",
            isPassword: true, controller: _passwordController),
        _entryField("Confirm Password",
            isPassword: true, controller: _confirmController),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = Utils.initializeProgressDialog(context);
    return Scaffold(
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Positioned(
                      top: -MediaQuery.of(context).size.height * .15,
                      right: -MediaQuery.of(context).size.width * .4,
                      child: BezierContainer()),
                  Container(
                    margin: EdgeInsets.only(top: 30.0),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
//                        _showProgress
//                            ? CircularProgressIndicator()
//                            : Text(_message,
//                                style: TextStyle(color: Colors.red)),
                        _inputWidget(),
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
                                'I agree to the terms & conditions',
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
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
//                  Align(
//                    alignment: Alignment.bottomCenter,
//                    child: _loginAccountLabel(),
//                  ),
                  Positioned(
                      top: 00,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.transparent,
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: <Widget>[
                            _backButton(),
                            Spacer(),
                            _title(),
                            Spacer(),
                            Spacer(),
                          ],
                        ),
                      )),
                ],
              ),
            )));
  }
}
