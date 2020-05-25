import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:quagga/src/utils/customer.dart';
import 'package:quagga/src/utils/utils.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fName = TextEditingController();
  final _lName = TextEditingController();
  final _cLocation = TextEditingController();
  final _cPhoneNumber = TextEditingController();
  final _cEmail = TextEditingController();

  File _image;
  bool _phoneError = false;
  ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();
    _fName.text = Utils.customerInfo.fName;
    _lName.text = Utils.customerInfo.sName;
    _cLocation.text = Utils.customerInfo.location;
    _cPhoneNumber.text = Utils.customerInfo.phone;
    _cEmail.text = Utils.customerInfo.email;
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = Utils.initializeProgressDialog(context);
    TextFormField inputName = TextFormField(
      controller: _fName,
      autofocus: false,
      keyboardType: TextInputType.text,
      inputFormatters: [
        LengthLimitingTextInputFormatter(45),
      ],
      decoration: InputDecoration(
          labelText: 'First Name',
          icon: Icon(Icons.person, color: LightColor.orange),
          labelStyle: TextStyle(color: Colors.grey)),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your first name';
        }
        return null;
      },
    );

    TextFormField inputNickName = TextFormField(
      controller: _lName,
      keyboardType: TextInputType.text,
      inputFormatters: [
        LengthLimitingTextInputFormatter(25),
      ],
      decoration: InputDecoration(
          labelText: "Surname",
          icon: Icon(Icons.person, color: LightColor.orange),
          labelStyle: TextStyle(color: Colors.grey)),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your surname';
        }
        return null;
      },
    );

    TextFormField inputLocation = TextFormField(
      controller: _cLocation,
      inputFormatters: [
        LengthLimitingTextInputFormatter(45),
      ],
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: 'Location',
          icon: Icon(Icons.location_on, color: LightColor.orange),
          labelStyle: TextStyle(color: Colors.grey)),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a detailed location';
        }
        return null;
      },
    );

    TextFormField inputPhoneNumber = TextFormField(
      controller: _cPhoneNumber,
      inputFormatters: [
        LengthLimitingTextInputFormatter(45),
      ],
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
          labelText: 'Phone',
          icon: Icon(Icons.phone, color: LightColor.orange),
          labelStyle: TextStyle(color: Colors.grey)),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a phone number';
        }
        return null;
      },
    );

    TextField inputEmail = TextField(
      enabled: false,
      enableInteractiveSelection: false,
      focusNode: FocusNode(),
      controller: _cEmail,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: 'E-mail',
          icon: Icon(Icons.email, color: LightColor.orange),
          labelStyle: TextStyle(color: Colors.grey)),
    );

    final picture = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          child: CircleAvatar(
            radius: 80,
            child: Icon(
              Icons.camera_alt,
              color: Colors.orange,
            ),
            backgroundColor: LightColor.lightGrey,
            backgroundImage:
                _image == null ? _loadProfileImage() : Image.file(_image).image,
          ),
          onTap: () {
            Utils.photoOptionDialog(context).then((int value) {
              if (value == 2) {
                Utils.getImageFromCamera(context).then((image) {
                    setState(() {
                    _image = image;
                    });
                });
              } else if (value == 1) {
                Utils.getImageFromGallery(context).then((image) {
                  setState(() {
                    _image = image;
                  });
                });
              }
            });
          },
        )
      ],
    );

    ListView content = ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        SizedBox(height: 20),
        picture,
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              inputName,
              inputNickName,
              inputLocation,
              inputPhoneNumber,
              _phoneError
                  ? Align(
                      alignment: Alignment.lerp(
                          Alignment.center, Alignment.topLeft, 0.6),
                      child: Text("Please enter a valid phone number",
                          style: TextStyle(fontSize: 12, color: Colors.red)),
                    )
                  : SizedBox(
                      height: 0.5,
                    ),
              inputEmail,
//              inputWebSite,
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Your Profile"),
        actions: <Widget>[
          Container(
            width: 80,
            child: IconButton(
              icon: Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Map<String, dynamic> body = {
                    "location": _cLocation.text,
                    "first_name": _fName.text,
                    "last_name": _lName.text,
                    "phone": _cPhoneNumber.text,
                    "customer_id": Utils.customerInfo.userID
                  };

                  _progressDialog.show();
                  _updateProfile(body).then((status) {
                    if (status) {
                      _updateProfileImage(_image, Utils.customerInfo.userID)
                          .then((state) {
                        // show dialog here

                        Future.delayed(Duration(seconds: 1)).then((value){
                          _progressDialog.hide().whenComplete(() async{
                            Utils.showStatus(context, state, "Profile updated");
                            _image = null;
                            await Utils.getUserProfile();
                          });
                        });
                      });
                    } else {
                      // show error dialog
                      if (_progressDialog.isShowing()) {
                        _progressDialog.hide().then((v)  {
                          Utils.showStatus(context, status, "");
                        });
                      }
                    }
                  });
                }
              },
            ),
          )
        ],
      ),
      body: content,
    );
  }

  Future<int> _photoOptionDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
//            title: Text("Select image from..."),
            content: Text("Get image from..."),
            actions: <Widget>[
              FlatButton(
                child: Text("Camera"),
                color: Colors.deepPurpleAccent,
                onPressed: () => Navigator.pop(context, 2),
              ),
              FlatButton(
                child: Text("Gallery"),
                color: Colors.blue,
                onPressed: () => Navigator.pop(context, 1),
              ),
              FlatButton(
                child: Text("Cancel"),
                color: Color(0xFFDC143C),
                onPressed: () => Navigator.pop(context, 0),
              )
            ],
          );
        });
  }

  Future _getImageFromCamera() async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: ImgSource.Camera,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );
    setState(() {
      _image = image;
    });
  }

  Future _getImageFromGallery() async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: ImgSource.Gallery,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );
    setState(() {
      _image = image;
    });
  }

  ImageProvider<dynamic> _loadProfileImage() {
    if (Utils.customerInfo.image.isEmpty) {
      return ExactAssetImage('assets/avatar.jpeg');
    } else {
      return NetworkImage(Utils.customerInfo.image);
    }
  }

  Future<bool> _updateProfile(Map<String, dynamic> body) async {
    String url = Utils.url + "/api/profile";

    String json = jsonEncode(body);

    try{
      var res = await http.put(url,
          headers: {
            "Authorization": Utils.token,
            "Content-Type": "application/json"
          },
          body: json);



      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    }catch(e){
      return false;
    }
  }

  Future<bool> _updateProfileImage(File file, int customerID) async {
    String url = Utils.url + "/api/profile";

    if (file == null) return true;

    print(file.path);

    var uri = Uri.parse(url);
    try {
      var request = http.MultipartRequest('POST', uri)
        ..fields['customer_id'] = customerID.toString()
        ..files.add(await http.MultipartFile.fromPath(
          'image',
          file.path,
        ));
      request.headers['Authorization'] = Utils.token;
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
