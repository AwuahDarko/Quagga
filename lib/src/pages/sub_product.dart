import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/shape/gf_avatar_shape.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/model/category.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/model/product.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';


class AddSubProduct extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddSubProductState();
  }
}

class AddSubProductState extends State<AddSubProduct> {
  final _formKey = GlobalKey<FormState>();
  final _pName = TextEditingController();
  final _description = TextEditingController();
  final _minOrder = TextEditingController();
  final _numStock = TextEditingController();
  final _price = TextEditingController();
  final _type = TextEditingController();

  File _image_1;
  File _image_2;
  File _image_3;
  File _image_4;
  ProgressDialog _progressDialog;

  List<int> _loadedImages = [];

  Product _product;

  @override
  Widget build(BuildContext context) {
    _progressDialog = Utils.initializeProgressDialog(context);
    TextFormField productName = TextFormField(
      controller: _pName,
      autofocus: false,
      keyboardType: TextInputType.text,
      inputFormatters: [
        LengthLimitingTextInputFormatter(45),
      ],
      decoration: InputDecoration(
          labelText: 'Product Name',
          labelStyle: TextStyle(color: Colors.grey)),
      validator: (value) {
        if (value.isEmpty) {
          return 'Product must have a name';
        }
        return null;
      },
    );

    TextFormField typeName = TextFormField(
      controller: _type,
      autofocus: false,
      keyboardType: TextInputType.text,
      inputFormatters: [
        LengthLimitingTextInputFormatter(45),
      ],
      decoration: InputDecoration(
          labelText: 'Type',
          labelStyle: TextStyle(color: Colors.grey)),
    );



    Card productDescription = Card(
        color: Colors.white70,
        child: TextFormField(
          autofocus: false,
          controller: _description,
          maxLines: 10,
          keyboardType: TextInputType.text,
          inputFormatters: [
            LengthLimitingTextInputFormatter(500),
          ],
          decoration: InputDecoration(
              hintText: "Enter product description here",
              labelStyle: TextStyle(color: Colors.grey)),
          validator: (value) {
            if (value.isEmpty) {
              return "Enter product description here";
            }
            return null;
          },
        ));

    TextFormField minOrder = TextFormField(
      autofocus: false,
      controller: _minOrder,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Min. Order',
          labelStyle: TextStyle(color: Colors.grey)
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a minimum order';
        }
        return null;
      },
    );

    TextFormField numberInStock = TextFormField(
      autofocus: false,
      controller: _numStock,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Quantity in stock',
          labelStyle: TextStyle(color: Colors.grey)),
      validator: (value) {
        if (value.isEmpty) {
          return 'How many is in stock';
        }
        return null;
      },
    );

    TextFormField _inputPrice = TextFormField(
      autofocus: false,
      controller: _price,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Price',
          labelStyle: TextStyle(color: Colors.grey)
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'What is the price?';
        }
        return null;
      },
    );

    DropdownButton productMenu = DropdownButton(
      hint: Text('Select main product'), // Not necessary for Option 1
      value: _product,
      onChanged: (newValue) {
        setState(() {
          _product = newValue;
        });
      },
      items: AppData.productList.map((product) {
        return DropdownMenuItem(
          child: new Text(product.name),
          value: product,
        );
      }).toList(),
    );

    StaggeredGridView content = StaggeredGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              productMenu,
              productName,
              typeName,
              minOrder,
              numberInStock,
              _inputPrice,
              productDescription,
              SizedBox(height: 15.0),
            ],
          ),
        ),
        GestureDetector(
          child: GFAvatar(
              child: Icon(Icons.camera),
              backgroundImage:
              _image_1 != null ? Image
                  .file(_image_1)
                  .image : null,
              shape: GFAvatarShape.standard),
          onTap: () {
            Utils.photoOptionDialog(context).then((value) {
              if (value == 2) {
                Utils.getImageFromCamera(context).then((file) {
                  _image_1 = file;
                  if (_image_1 != null) {
                    _loadedImages.add(1);
                  }
                  setState(() {

                  });
                });
              } else if (value == 1) {
                Utils.getImageFromGallery(context).then((file) {
                  _image_1 = file;
                  if (_image_1 != null) {
                    _loadedImages.add(1);
                  }
                  setState(() {

                  });
                });
              }
            });
          },
        ),
      ],
      staggeredTiles: [
        StaggeredTile.fit(2),
        StaggeredTile.extent(2, 130.0),

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
        title: Text("Sub Product"),
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
                  if (_product == null) {
                    showInvalid(context, "Sub-product must be under a main product");
                    return;
                  }

                  if (_image_1 == null) {
                    showInvalid(
                        context, "Product must have an image");
                    return;
                  }

                  Map<String, dynamic> body = {
                    "name": _pName.text,
                    "description": _description.text,
                    "price": _price.text,
                    "min_order": _minOrder.text,
                    "number_in_stock": _numStock.text,
                    "discount": 0.0,
                    "image_url": "",
                    "type": _type.text,
                    "product_id": _product.id
                  };


                  _progressDialog.show().then((v){
                    _addSubProduct(body).then((result){
                      if(result == false){
                        if(_progressDialog.isShowing()){
                          _progressDialog.hide().then((v){
                            Utils.showStatus(context, result, "");
                          });
                        }
                      }else{
                        _uploadImages(result).then((status){
                          if(_progressDialog.isShowing()){
                            _progressDialog.hide().then((v){
                              Utils.showStatus(context, status, "New sub-product added to ${_product.name}");
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


  void showInvalid(BuildContext context, String message) {
    var alertDialog = AlertDialog(
        title: Text("Invalid", style: TextStyle(
            fontSize: 20,
            color: Colors.green
        ),),
        content: Text(message)
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  Future<dynamic> _addSubProduct(Map<String, dynamic> body) async {
    String url = Utils.url + "/api/sub-products";

    String json = jsonEncode(body);

    try{
      var res = await http.post(
          url,
          headers: {
            "Authorization": Utils.token,
            "Content-Type": "application/json"
          },
          body: json
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        Map<String, dynamic> result = jsonDecode(res.body);
        return result['type_id'];
      } else {
        return false;
      }
    }catch(e){
      return false;
    }
  }

  Future<bool> _uploadImages(int typeID) async {
    String url = Utils.url + "/api/sub-product-image";

    FormData formData = FormData.fromMap({
      "product_image": MultipartFile.fromFileSync(_image_1.path, filename: _image_1.path.split("/").last),
      "type_id": typeID
    });

    Dio dio = Dio();
    dio.options.headers["Authorization"] = Utils.token;
    var res = await dio.put(url, data: formData);

    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
