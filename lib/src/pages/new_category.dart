import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/utils/utils.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class NewCategory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewCategoryState();
  }
}

class NewCategoryState extends State<NewCategory> {
  final _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController();
  ProgressDialog _progressDialog;
  File _image;

  @override
  Widget build(BuildContext context) {
    _progressDialog = Utils.initializeProgressDialog(context);
    TextFormField inputName = TextFormField(
      controller: _categoryController,
      autofocus: false,
      keyboardType: TextInputType.text,
      inputFormatters: [
        LengthLimitingTextInputFormatter(45),
      ],
      decoration: InputDecoration(
          labelText: 'Category Name',
          icon: Icon(Icons.description, color: LightColor.orange),
          labelStyle: TextStyle(color: Colors.grey)),
      validator: (value) {
        if (value.isEmpty) {
          return 'Category must have a name';
        }
        return null;
      },
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
            backgroundImage: _image == null
                ? ExactAssetImage('assets/hold.png')
                : Image.file(_image).image,
          ),
          onTap: () {
            Utils.photoOptionDialog(context).then((value) {
              if (value == 2) {
                Utils.getImageFromCamera(context).then((file) {
                  setState(() {
                    _image = file;
                  });
                });
              } else if (value == 1) {
                Utils.getImageFromGallery(context).then((file) {
                  setState(() {
                    _image = file;
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
                  _progressDialog.show().then((v) {
                    _setNewCategory(_categoryController.text).then((result) {
                      if (result == false) {
                        if(_progressDialog.isShowing()){
                          _progressDialog.hide().then((v){
                            Utils.showStatus(
                                context, result, "New category created");
                          });
                        }
                      } else {
                        _setCategoryImage(_image, result).then((status) {
                          if(_progressDialog.isShowing()){
                            _progressDialog.hide().then((v){
                              Utils.showStatus(
                                  context, status, "New category created");
                            });
                          }

                        });
                      }
                    });
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

  Future<dynamic> _setNewCategory(String name) async {
    String url = Utils.url + "/api/categories";
    Map<String, String> body = {"category_name": name};

    String json = jsonEncode(body);

    var res = await http.post(url,
        headers: {
          "Authorization": Utils.token,
          "Content-Type": "application/json"
        },
        body: json);

    if (res.statusCode == 200 || res.statusCode == 201) {
      Map<String, dynamic> result = jsonDecode(res.body);
      return result['category_id'];
    } else {
      return false;
    }
  }

  Future<bool> _setCategoryImage(file, int categoryID) async {
    String url = Utils.url + "/api/category-image";

    if (file == null) {
      return true;
    }

    FormData formData = FormData.fromMap({
      "category_image": await MultipartFile.fromFile(file.path,
          filename: file.path.split("/").last),
      "category_id": categoryID
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
}
