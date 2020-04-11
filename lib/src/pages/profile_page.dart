import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masked_text/masked_text.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'dart:io';

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
  final _cWebSite = TextEditingController();

  File _image;
  bool _phoneError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

    TextFormField inputWork = TextFormField(
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

    MaskedTextField inputPhoneNumber = new MaskedTextField(
      maskedTextFieldController: _cPhoneNumber,
      mask: "(xxx) xxx-xxx-xxx",
      maxLength: 16,
      keyboardType: TextInputType.phone,
      inputDecoration: new InputDecoration(
          labelText: "Phone",
          icon: Icon(
            Icons.phone,
            color: LightColor.orange,
          ),
          labelStyle: TextStyle(color: Colors.grey)),
    );

    TextFormField inputEmail = TextFormField(
      controller: _cEmail,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: 'E-mail',
          icon: Icon(Icons.email, color: LightColor.orange),
          labelStyle: TextStyle(color: Colors.grey)),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your e-mail';
        }
        return null;
      },
    );

    TextFormField inputWebSite = TextFormField(
      controller: _cWebSite,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: 'Website',
          icon: Icon(Icons.web, color: LightColor.orange),
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
            ),
            backgroundColor: LightColor.orange,
            backgroundImage: _image == null
                ? ExactAssetImage('assets/avatar.jpeg')
                : Image.file(_image).image,
          ),
          onTap: () {
            _photoOptionDialog(context).then((int value) {
              if (value == 2) {
                _getImageFromCamera();
              }else if(value == 1){
                _getImageFromGallery();
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
              inputWork,
              inputPhoneNumber,
              _phoneError ? Align(
                alignment: Alignment.lerp(Alignment.center, Alignment.topLeft, 0.6),
                child: Text("Please enter a valid phone number", style: TextStyle(
                    fontSize: 12,
                    color: Colors.red
                )),
              ): SizedBox(height: 0.5,),
              inputEmail,
              inputWebSite,
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
                  if(_cPhoneNumber.text.isEmpty){
                    _phoneError = true;
                    setState((){});
                    return;
                  }
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
}
